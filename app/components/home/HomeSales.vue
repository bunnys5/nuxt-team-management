<script setup lang="ts">
import { ref, onMounted } from "vue";
import axios from "axios";
import Cookies from "js-cookie";

// Get token from cookies
const token = Cookies.get("jwt");
const users = ref([]); // This will store the fetched users
const sales = ref([]); // This will store the sales data
const salesDescription = ref(""); // Description for sales count

// Function to fetch user data from the API
const fetchData = async () => {
  try {
    const response = await axios.get("http://localhost:8080/api/users", {
      headers: {
        Authorization: `Bearer ${token}`, // Attach token in Authorization header
      },
    });
    const userData = response.data.users;

    // Get the current month and year
    const currentMonth = new Date().getMonth();
    const currentYear = new Date().getFullYear();

    // Filter users created in the current month
    const currentMonthUsers = userData.filter((user) => {
      const userDate = new Date(user.created_at);
      return (
        userDate.getMonth() === currentMonth &&
        userDate.getFullYear() === currentYear
      );
    });

    // Update the sales description with the count of current month users
    salesDescription.value = `Users created ${currentMonthUsers.length} accounts this month.`;

    // Sort users by created_at in descending order
    const sortedUsers = userData.sort(
      (a, b) =>
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    );

    // Select the top 4 users for sales and format their data
    sales.value = sortedUsers.slice(0, 4).map((user) => ({
      user: {
        name: user.firstname + " " + user.lastname, // Combine firstname and lastname
        email: user.email,
        avatar: {
          src: "https://via.placeholder.com/128?text=User+Icon", // Default avatar if not provided
        },
      },
      createdAt: new Date(user.created_at).toLocaleString("en-US", {
        year: "numeric",
        month: "long",
        day: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        hour12: true,
      }), // Format the created_at date
    }));

    // You can also assign the user data to `users` for display
    users.value = userData;

    console.log(users.value);
    console.log(sales.value);
  } catch (error) {
    console.error("Error fetching users:", error);
  }
};

// Fetch the data on component mount
onMounted(() => {
  fetchData();
});
</script>

<template>
  <UDashboardCard
    title="Recent Users"
    :description="salesDescription"
    icon="i-heroicons-chart-bar-20-solid"
  >
    <NuxtLink
      v-for="(sale, index) in sales"
      :key="index"
      class="px-3 py-2 -mx-2 last:-mb-2 rounded-md hover:bg-gray-50 dark:hover:bg-gray-800/50 cursor-pointer flex items-center gap-3 relative"
    >
      <UAvatar v-bind="sale.user.avatar" :alt="sale.user.name" size="md" />

      <div class="text-sm flex-1">
        <div>
          <p class="text-gray-900 dark:text-white font-medium">
            {{ sale.user.name }}
          </p>
          <p class="text-gray-500 dark:text-gray-400">
            {{ sale.user.email }}
          </p>
        </div>
      </div>

      <!-- Display the formatted createdAt date -->
      <p class="text-gray-900 dark:text-white font-medium text-lg">
        {{ sale.createdAt }}
        <!-- Show formatted date and time -->
      </p>
    </NuxtLink>
  </UDashboardCard>
</template>
