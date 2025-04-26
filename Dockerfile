# Step 1: Build the Next.js app
FROM node:22-alpine AS build

WORKDIR /app

# Copy dependencies and package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the code
COPY . .

# Build the Next.js app
RUN npm run build

# Step 2: Run the Next.js app
FROM node:22-alpine AS runtime

WORKDIR /app

# Copy ONLY the built app and node_modules
COPY --from=build /app/.next /app/.next
COPY --from=build /app/public /app/public
COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/package.json /app/package.json

# Expose the app port
EXPOSE 2791

# Start the app
CMD ["npm", "start"]
