# Step 1: Build the Next.js app
FROM node:22-alpine as build

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
FROM node:22-alpine as runtime

WORKDIR /app

# Copy the build from the previous stage
COPY --from=build /app /app

# Install production dependencies
RUN npm install --production

# Expose the default Next.js port
EXPOSE 2791

CMD ["npm", "start"]