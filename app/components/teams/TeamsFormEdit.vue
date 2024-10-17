<script setup lang="ts">
import { ref, watch, onMounted } from "vue";
import axios from "axios";
import type { FormError, FormSubmitEvent } from "#ui/types";
import Cookies from "js-cookie";

const emit = defineEmits(["close"]);
const token = Cookies.get("jwt");

// Define props
const props = defineProps<{
  team_id: number | null;
  team_name: string | null;
}>();

const state = ref({
  team_name: props.team_name || "", // Initialize with the passed `team_name` value
  team_id: props.team_id || null,
});

const teams = ref([]); // Store teams data

// Fetch teams from API
const fetchTeams = async () => {
  try {
    const response = await axios.get("http://localhost:8080/api/teams", {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    }); // Update the URL as necessary
    teams.value = response.data.teams; // Assuming the response returns an array of teams
    console.log("data team here", teams);
    console.log(teams);
  } catch (error) {
    console.error("Error fetching teams:", error);
  }
};

// Watch for changes in the user prop to update the state
watch(
  () => props.team_name,
  (newTeamName) => {
    if (newTeamName) {
      state.value.team_name = newTeamName; // Update state with the new team name
    }
  },
  { immediate: true }
);

watch(
  () => props.team_id,
  (newTeamId) => {
    if (newTeamId) {
      state.value.team_id = newTeamId; // Update the team_id when it changes
    }
  },
  { immediate: true } // This ensures the watcher runs immediately after component initialization
);

// Validate function
const validate = (state: any): FormError[] => {
  const errors = [];
  if (state.team_name === null)
    errors.push({ path: "team_name", message: "Please input team name." });
  return errors;
};

// Handle form submission
// TeamsDeleteForm.vue
const onSubmit = async (event: Event) => {
  event.preventDefault();
  if (!state.value.team_name) {
    console.error("Team name is required");
    return;
  }

  console.log("Submitting with team_id:", state.value.team_id); // Check team_id value here

  try {
    await axios.patch(
      `http://localhost:8080/api/teams/${state.value.team_id}`,
      {
        team_name: state.value.team_name,
      },
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    console.log("Team updated successfully");
    emit("close");
  } catch (error) {
    console.error("Error updating team:", error);
  }
};

// Fetch teams when the component is mounted
onMounted(() => {
  fetchTeams();
});
</script>

<template>
  <UForm
    :validate="validate"
    :validate-on="['submit']"
    :state="state"
    class="space-y-4"
    @submit="onSubmit"
  >
    <UFormGroup label="Team name" name="team_name">
      <UInput v-model="state.team_name" placeholder="Team Name" autofocus />
    </UFormGroup>

    <div class="flex justify-end gap-3">
      <UButton
        label="Cancel"
        color="gray"
        variant="ghost"
        @click="emit('close')"
      />
      <UButton type="submit" label="Save" color="black" />
    </div>
  </UForm>
</template>
