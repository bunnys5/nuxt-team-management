<script setup lang="ts">
import { ref, watch } from "vue";
import axios from "axios";
import type { FormError, FormSubmitEvent } from "#ui/types";
import Cookies from "js-cookie";

const token = Cookies.get("jwt");
const emit = defineEmits(["close"]);
const showErrorDialog = ref(false);
const errorMessage = ref("");
// Define props
const props = defineProps<{
  team_id: number | null; // Accept team_id as number or null initially
}>();

// Reactive state for form fields
const state = ref({
  team_id: "",
});

// Watch for changes in the user prop to update the state
watch(
  () => props.team_id,
  (newTeamId) => {
    if (newTeamId) {
      state.value.team_id = newTeamId; // Update state with the new team_id
    }
  },
  { immediate: true }
);

// Handle form submission
async function onSubmit(event: Event) {
  event.preventDefault(); // Prevent default form submission behavior

  if (!props.team_id) {
    console.error("No user data available for deletion");
    emit("close"); // Close the modal if no team is available
    return;
  }

  try {
    // Send delete request to the API using the team's ID
    await axios.delete(`http://localhost:8080/api/teams/${props.team_id}`, {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    });
    console.log("Team deleted successfully");

    emit("close"); // Close the main modal after successful action
  } catch (error) {
    if (error.response && error.response.status === 500) {
      errorMessage.value =
        "Please remove people from the team first or remove people from the team before deleting the team.";
      showErrorDialog.value = true; // Show the error dialog on server error
    } else {
      console.error("Error deleting team:", error);
    }
  }
}
</script>

<template>
  <UForm
    :validate="validate"
    :validate-on="['submit']"
    :state="state"
    class="space-y-4"
    @submit="onSubmit"
  >
    <UFormGroup>
      <div>
        <p>Are you sure you want to delete this team?</p>
      </div>
    </UFormGroup>

    <div class="flex justify-end gap-3">
      <!-- Cancel button to close the modal -->
      <UButton
        label="Cancel"
        color="gray"
        variant="ghost"
        @click="emit('close')"
      />
      <!-- Save (Submit) button -->
      <UButton type="submit" label="Save" color="black" />
    </div>
  </UForm>

  <!-- Error Dialog -->
  <UDashboardModal
    v-if="showErrorDialog"
    v-model="showErrorDialog"
    title="Error"
  >
    <div class="p-4">
      <p>{{ errorMessage }}</p>
      <div class="flex justify-end mt-4">
        <!-- Button to close the error modal -->
        <UButton label="OK" color="blue" @click="showErrorDialog = false" />
      </div>
    </div>
  </UDashboardModal>
</template>
