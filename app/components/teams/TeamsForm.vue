<script setup lang="ts">
import axios from "axios";
import { reactive } from "vue";
import Cookies from "js-cookie";
import type { FormError, FormSubmitEvent } from "#ui/types";

const emit = defineEmits(["close"]);
const token = Cookies.get("jwt");
// สถานะฟอร์ม พร้อมฟิลด์ที่จำเป็น
const state = reactive({
  team_name: "",
});

// สถานะสำหรับทีม
const teams = reactive([]); // สร้างสถานะเพื่อเก็บข้อมูลทีม

// ฟังก์ชันตรวจสอบความถูกต้องของฟอร์ม
const validate = (state: any): FormError[] => {
  const errors = [];
  if (!state.team_name)
    errors.push({ path: "team_name", message: "Please enter a team name." });
  return errors;
};

// ฟังก์ชันจัดการเมื่อกดปุ่ม Submit
async function onSubmit(event) {
  try {
    // Create the data object to be sent
    const teamData = {
      team_name: state.team_name,
    };

    // Log the data to the console
    console.log("User data to be sent:", teamData);

    // Send data to the API to create a new user
    const response = await axios.post(
      "http://localhost:8080/api/teams",
      teamData,
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
    console.error("Error creating teamData:", error);
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

const editUser = async (teamId: number) => {
  try {
    const response = await axios.get(
      `http://localhost:8080/api/teams/${teamId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    selectedUser.value = response.data.team; // Make sure the API returns the team details, including `team_name`
    isNewUserModalOpenEdit.value = true; // Open the edit modal
  } catch (error) {
    console.error("Error fetching team data:", error);
  }
};

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
    <UFormGroup label="Team name " name="firstname">
      <UInput v-model="state.team_name" placeholder="Name" />
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
