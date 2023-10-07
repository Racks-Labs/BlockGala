import { useAddress } from "@thirdweb-dev/react";
import { NextPage } from "next";

const Home: NextPage = () => {
  const address = useAddress();

  return (
    <main
      className="min-h-screen min-w-screen bg-cover bg-center bg-no-repeat flex items-center justify-center flex-col pb-12"
      style={{
        backgroundImage: `
            radial-gradient(circle farthest-side at -15% 85%, rgba(90, 122, 255, .36), rgba(0, 0, 0, 0) 42%),
            radial-gradient(circle farthest-side at 100% 30%, rgba(245, 40, 145, 0.25), rgba(0, 0, 0, 0) 60%)
          `,
      }}
    >
      <div className="px-2">
        <h1 className="mt-20 text-4xl font-extrabold tracking-tight lg:text-5xl text-center">
          BlockGala 🎟️
        </h1>
        <p className="text-xl text-muted-foreground mt-6 text-center mb-8">
          Pushing the Boundaries of What a Subscription Can Be.
        </p>
      </div>
    </main>
  );
};

export default Home;
