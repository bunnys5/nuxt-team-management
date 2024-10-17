<script setup lang="ts">
import { ref, watch, onMounted } from "vue";
import axios from "axios";
import type { FormError, FormSubmitEvent } from "#ui/types";
import Cookies from "js-cookie";

const emit = defineEmits(["close"]);
const token = Cookies.get("jwt");
// Define props
const props = defineProps<{
  user: {
    id: number;
    username: string;
    password: string;
    firstname: string;
    lastname: string;
    email: string;
    phone: string;
    role: string;
    team_id: number; // Add team_id to user props
  };
}>();

// Reactive state for form fields
const state = ref({
  username: "",
  password: "",
  firstname: "",
  lastname: "",
  email: "",
  phone: "",
  role: "user",
  team_id: null, // Initialize team_id
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
    console.log(teams);
  } catch (error) {
    console.error("Error fetching teams:", error);
  }
};

// Watch for changes in the user prop to update the state
watch(
  () => props.user,
  (newUser) => {
    if (newUser) {
      state.value = { ...newUser }; // Populate form fields with user data
    }
  },
  { immediate: true } // Run on initial load
);

// Validate function
const validate = (state: any): FormError[] => {
  const errors = [];
  if (!state.username)
    errors.push({ path: "username", message: "Please enter a username." });
  if (!state.password)
    errors.push({ path: "password", message: "Please enter a password." });
  if (!state.firstname)
    errors.push({ path: "firstname", message: "Please enter a first name." });
  if (!state.lastname)
    errors.push({ path: "lastname", message: "Please enter a last name." });
  if (!state.email)
    errors.push({ path: "email", message: "Please enter an email." });
  if (!state.phone)
    errors.push({ path: "phone", message: "Please enter a phone number." });
  if (state.team_id === null)
    errors.push({ path: "team_id", message: "Please select a team." });
  return errors;
};

// Handle form submission
async function onSubmit(event: FormSubmitEvent<any>) {
  try {
    const data = {
      username: state.value.username,
      password: state.value.password,
      firstname: state.value.firstname,
      lastname: state.value.lastname,
      email: state.value.email,
      phone: state.value.phone,
      role: state.value.role,
      team_id: state.value.team_id, // Include team_id in the submission
    };

    console.log(data);

    // Send data to the API to update the user
    const response = await axios.patch(
      `http://localhost:8080/api/users/${props.user.id}`,
      data,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );

    console.log("User updated successfully:", response);
    emit("close");
  } catch (error) {
    console.error("Error updating user:", error);
  }
}

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
    <UFormGroup label="Username" name="username">
      <UInput v-model="state.username" placeholder="Enter username" autofocus />
    </UFormGroup>

    <UFormGroup label="Password" name="password">
      <UInput
        v-model="state.password"
        type="password"
        placeholder="Enter password"
      />
    </UFormGroup>

    <UFormGroup label="First Name" name="firstname">
      <UInput v-model="state.firstname" placeholder="Enter first name" />
    </UFormGroup>

    <UFormGroup label="Last Name" name="lastname">
      <UInput v-model="state.lastname" placeholder="Enter last name" />
    </UFormGroup>

    <UFormGroup label="Email" name="email">
      <UInput v-model="state.email" type="email" placeholder="Enter email" />
    </UFormGroup>

    <UFormGroup label="Phone" name="phone">
      <UInput
        v-model="state.phone"
        type="tel"
        placeholder="Enter phone number"
      />
    </UFormGroup>

    <UFormGroup label="Role" name="role">
      <UInput v-model="state.role" type="role" placeholder="Enter role" />
    </UFormGroup>
    <UFormGroup label="Teams" name="teams">
      <USelect
        class="text-white"
        v-model="state.team_id"
        :options="
          teams.map((team) => ({
            value: Number(team.team_id),
            label: team.team_name,
          })) // Convert team_id to a number
        "
        placeholder="Select a team"
      />
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
