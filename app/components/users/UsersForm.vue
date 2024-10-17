<script setup lang="ts">
import axios from "axios";
import { reactive } from "vue";
import Cookies from "js-cookie";
import type { FormError, FormSubmitEvent } from "#ui/types";

const emit = defineEmits(["close"]);
const token = Cookies.get("jwt");
// สถานะฟอร์ม พร้อมฟิลด์ที่จำเป็น
const state = reactive({
  username: "",
  password: "",
  firstname: "",
  lastname: "",
  email: "",
  phone: "",
  role: "", // กำหนดค่า role เริ่มต้นเป็น 'user'
  team_id: null, // เพิ่มฟิลด์ team_id
});

// สถานะสำหรับทีม
const teams = reactive([]); // สร้างสถานะเพื่อเก็บข้อมูลทีม

// ฟังก์ชันตรวจสอบความถูกต้องของฟอร์ม
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
  if (!state.team_id)
    errors.push({ path: "team_id", message: "Please select a team." }); // ตรวจสอบว่าเลือกทีมแล้ว
  return errors;
};

// ฟังก์ชันจัดการเมื่อกดปุ่ม Submit
async function onSubmit(event) {
  try {
    // Create the data object to be sent
    const userData = {
      username: state.username,
      password: state.password,
      firstname: state.firstname,
      lastname: state.lastname,
      email: state.email,
      phone: state.phone,
      role: state.role,
      team_id: Number(state.team_id), // Ensure team_id is a number
    };

    // Log the data to the console
    console.log("User data to be sent:", userData);

    // Send data to the API to create a new user
    const response = await axios.post(
      "http://localhost:8080/api/users",
      userData,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    console.log("User created successfully:", response);

    emit("userCreated");

    // Close modal after successful creation
    emit("close");
  } catch (error) {
    console.error("Error creating user:", error);
  }
}

async function fetchTeams() {
  try {
    const response = await axios.get("http://localhost:8080/api/teams", {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    });
    teams.push(...response.data.teams); // เก็บข้อมูลทีมใน state
  } catch (error) {
    console.error("Error fetching teams:", error);
  }
}

// เรียกใช้ fetchTeams เมื่อ component ถูกสร้าง
onMounted(fetchTeams);
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
