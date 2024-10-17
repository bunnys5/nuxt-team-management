<script setup lang="ts">
import { ref, computed, onMounted } from "vue";
import type { User } from "~/types";
import axios from "axios";
import Cookies from "js-cookie";
import UsersFormEdit from "~/components/users/UsersFormEdit.vue";
import { useRouter } from "vue-router";

const defaultColumns = [
  {
    key: "team_name",
    label: "Team Name",
  },
  {
    key: "created_at",
    label: "Created At",
  },
  {
    key: "edit",
    label: "",
  },
];

const router = useRouter();
const token = Cookies.get("jwt");
const q = ref("");
const selected = ref<User[]>([]);
const selectedColumns = ref(defaultColumns);
const sort = ref({ column: "id", direction: "asc" as const });
const input = ref<{ input: HTMLInputElement }>();
const isNewUserModalOpen = ref(false);
const isNewUserModalOpenEdit = ref(false);
const isNewUserModalOpenDelete = ref(false);

const columns = computed(() =>
  defaultColumns.filter((column) => selectedColumns.value.includes(column))
);

const fetchData = async () => {
  try {
    // ทำการเรียก API โดยแนบ token ใน header
    const response = await axios.get("http://localhost:8080/api/teams", {
      headers: {
        Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
      },
    });

    console.log(response);
    const userData = response.data.teams;

    // คุณสามารถกำหนดค่า user data ให้กับ `users` เพื่อแสดงผล
    users.value = userData;
    console.log(users);
  } catch (error) {
    console.error("Error fetching users:", error);
  }
};
onMounted(async () => {
  fetchData();
});

const users = ref<User[]>([]); // Define users as a ref to store user data

function onSelect(row: User) {
  const index = selected.value.findIndex((item) => item.id === row.id);
  if (index === -1) {
    selected.value.push(row);
  } else {
    selected.value.splice(index, 1);
  }
}

defineShortcuts({
  "/": () => {
    input.value?.input?.focus();
  },
});

const selectedUser = ref<User | null>(null); // Track the user to edit

const editUser = async (teamId: number) => {
  try {
    // ทำการเรียก API โดยแนบ token ใน header
    const response = await axios.get(
      `http://localhost:8080/api/teams/${teamId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`, // แนบ token ใน Authorization header
        },
      }
    );
    selectedUser.value = response.data.team; // ตรวจสอบว่าข้อมูลทีมถูกต้อง
    isNewUserModalOpenEdit.value = true; // เปิด modal สำหรับแก้ไข
  } catch (error) {
    console.error("Error fetching team data:", error);
  }
};
const deleteUser = async (team_id: number) => {
  try {
    console.log("check id", team_id);
    isNewUserModalOpenDelete.value = true; // Open the delete modal
    selectedUser.value = { team_id }; // Set the team ID to be passed to the delete form
  } catch (error) {
    console.error("Error preparing team for deletion:", error);
  }
};
</script>

<template>
  <UDashboardPage>
    <UDashboardPanel grow>
      <UDashboardNavbar title="Teams" :badge="users.length">
        <template #right>
          <UButton
            label="New team"
            trailing-icon="i-heroicons-plus"
            color="gray"
            @click="isNewUserModalOpen = true"
          />
        </template>
      </UDashboardNavbar>
      <UDashboardModal
        v-model="isNewUserModalOpen"
        title="New team"
        description="Add a new team"
        :ui="{ width: 'sm:max-w-md' }"
      >
        <!-- ~/components/users/UsersForm.vue -->
        <TeamsForm @close="isNewUserModalOpen = false" />
      </UDashboardModal>
      <UDashboardModal
        v-model="isNewUserModalOpenEdit"
        title="Edit team"
        description="Edit team"
      >
        <TeamsFormEdit
          :team_id="selectedUser.team_id"
          :team_name="selectedUser.team_name"
          @close="isNewUserModalOpenEdit = false"
        />
      </UDashboardModal>
      <UDashboardModal v-model="isNewUserModalOpenDelete" title="Delete team">
        <TeamsFormDelete
          @close="isNewUserModalOpenDelete = false"
          :team_id="selectedUser.team_id"
        />
      </UDashboardModal>

      <UTable
        :rows="users"
        :columns="columns"
        :loading="pending"
        sort-mode="manual"
        class="w-full"
        :ui="{ divide: 'divide-gray-200 dark:divide-gray-800' }"
        @select="onSelect"
      >
        <template #name-data="{ row }">
          <div class="flex items-center gap-3">
            <span class="text-gray-900 dark:text-white font-medium">{{
              row.team_name
            }}</span>
          </div>
        </template>

        <template #firstname-data="{ row }">
          <span>{{ row.created_at }}</span>
        </template>

        <template #role-data="{ row }">
          <UBadge
            :label="row.role"
            :color="green"
            variant="subtle"
            class="capitalize"
          />
        </template>

        <!-- open UsersFormEdit and send params id too -->
        <template #edit-data="{ row }">
          <div class="space-x-3">
            <UButton
              size="sm"
              color="blue"
              icon="i-heroicons-eye"
              @click="() => router.push(`teams/users/${row.team_id}`)"
            />
            <UButton
              size="sm"
              color="blue"
              icon="i-heroicons-pencil"
              @click="editUser(row.team_id)"
            />
            <UButton
              size="sm"
              color="red"
              icon="i-heroicons-trash"
              @click="deleteUser(row.team_id)"
            />
          </div>
        </template>
      </UTable>
    </UDashboardPanel>
  </UDashboardPage>
</template>
