<script setup lang="ts">
import { ref, watch } from "vue";
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
  } | null; // Allow user to be null initially
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
});

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

// Handle form submission
async function onSubmit(event: Event) {
  event.preventDefault(); // Prevent default form submission behavior

  if (!props.user) {
    console.error("No user data available for deletion");
    emit("close"); // Close the modal if no user is available
    return;
  }

  try {
    // Send delete request to the API using the user's ID
    await axios.delete(`http://localhost:8080/api/users/${props.user.id}`, {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    });
    console.log("User deleted successfully");
    emit("close");
  } catch (error) {
    console.error("Error deleting user:", error);
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
        <p>Are you sure to delete this user?</p>
      </div>
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
