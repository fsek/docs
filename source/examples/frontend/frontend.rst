Frontend Code Tutorial
======================

In this tutorial, we will create an admin page for managing fruits using our backend API. Frontend code can be very verbose, so don't worry if you don't understand every line. The goal here is to give you a basic idea of how to set up a frontend page that interacts a backend object very similar to the one we created in :ref:`the backend tutorial <backend_tutorial>`. You don't have to have done that tutorial to follow along here, all the code will be provided.

.. note::
    This tutorial will focus on viewing and adding fruits only. While full CRUD (Create, Read, Update, Delete) operations are typically implemented in production applications, we'll keep this tutorial simpler by implementing only the viewing and adding functionality. If you want to add editing and deleting features later, you can look at other admin pages in the codebase for examples.


.. warning::
    The code from this tutorial is intentionally oversimplified. Don't use it as a basis for new features in production.

Preparation
-----------

To work through this tutorial, you will need:

- A local copy of the frontend codebase. Install it using the `github README instructions`_.
- A local copy of the backend codebase. Install it using the `github README instructions for backend`_.
- Git installed and configured on your machine. Use only the git part of :ref:`this guide <install_git>`.

.. _`github README instructions`: https://github.com/fsek/WWW-Web
.. _`github README instructions for backend`: https://github.com/fsek/WebWebWeb

How the Frontend Works
----------------------

The frontend is built using Next.js, a popular React framework for building web applications. It uses TypeScript, a typed superset of JavaScript that adds static types to the language. The frontend communicates with the backend and serves as the user interface for interacting with the backend API. Both the frontend and backend are processes that run on the server, but the frontend also sends code to the user's browser to be executed there. When a user clicks on a "save" button, their local client version of the frontend code sends a request directly to the backend API running on the main server to save the data. When they click on a link to view a page, the frontend code running on the server generates the HTML (it's a bit more complicated than that, but that's the basic idea) and sends it to the user's browser to be displayed. When you are building the frontend, you are therefore working both with code that runs on the server and code that runs on the client; if you're unsure which side a piece of code runs on, assume it must be safe for both.

Create a Git Branch
-------------------

Git is great for keeping track of changes in code. You should always create a new branch when working on a new feature or bugfix. This keeps your changes organized and makes it easier for others to help you later on. First run this to make sure you are up to date with the latest changes, and branch off the main branch:::

    git checkout main
    git pull origin main

Now we want to create the new branch. You should run this in the terminal:::

    git checkout -b COOL-NAME-FOR-YOUR-BRANCH

Replace ``COOL-NAME-FOR-YOUR-BRANCH`` with a descriptive name for your branch. If you already have local changes, commit or stash them before switching branches to avoid conflicts.

Starting the Backend
--------------------

A backend branch containing all the necessary changes to support the fruit admin page has already been created for you. You want to switch to that branch in your local backend repository. Run these commands in the terminal:::

    git checkout fruits-example-2026
    git pull origin fruits-example-2026

Now rebuild the backend (``Crtl+Shift+P`` in VSCode and select ``Dev Containers: Rebuild Container``) so that the new changes are applied. After rebuilding, start the backend server. You should check that it is running by opening ``http://localhost:8000/docs`` in your web browser. You should see the API documentation page and be able to see the ``/fruits/`` endpoint. This is what you'll be interacting with from the frontend.

For the frontend to know about these changes, you have to regenerate the API specification in the frontend codebase. Go to the frontend repository and run this command in the terminal:::

    bun run generate-api

This should automatically create new files in ``src/api/`` which the frontend will use to know how it can interact with the backend API. 

.. warning::
    If you forget to run ``bun run generate-api`` after pulling backend changes, the generated API client may be outdated and your queries/mutations will fail with confusing errors.

Creating the Fruit Admin Page
-----------------------------

After this tutorial, I recommend copying and modifying code from existing pages to create new pages, as this is often faster than writing everything from scratch. However, for this tutorial, I'll go through the file we want step by step so you can understand how it works.

Our page has to be located in the right place so that next.js can serve it correctly. Create a new folder called ``fruits`` at ``src/app/admin/``. Inside that folder, create a new file called ``page.tsx``. This file will contain the main code for our fruit admin page.

Open the file and add the following code to the top:::

    "use client";

    import { ActionEnum, TargetEnum, type FruitRead } from "@/api";
    import { useSuspenseQuery } from "@tanstack/react-query";
    import { getAllFruitsOptions } from "@/api/@tanstack/react-query.gen";
    import { createColumnHelper, type Row } from "@tanstack/react-table";
    import AdminTable from "@/widgets/AdminTable";
    import useCreateTable from "@/widgets/useCreateTable";
    import { useTranslation } from "react-i18next";
    import { useState, Suspense } from "react";
    import PermissionWall from "@/components/PermissionWall";
    import { LoadingErrorCard } from "@/components/LoadingErrorCard";

This code imports all the necessary modules and components we will use in our page. The ``"use client";`` directive at the top tells Next.js that this file should run on the client side (i.e., in the user's browser), which is standard (and necessary) for interactive pages.

This is a good time to give a brief overview of how the page will look when it's done. The page will display a table of fruits, allowing users to view and add fruit entries. Each fruit will have properties like name, color, and price. There will be a button above the table to add new fruits.

The table needs a helper which keeps track of the columns and makes it easier to define them. Add this code below the imports:::

    const columnHelper = createColumnHelper<FruitRead>();

As you can see, we are using the ``FruitRead`` type that was generated when we ran ``bun run generate-api`` earlier. This type represents the data structure of a fruit as returned by the backend API.

The next thing we do is to define the columns of the table. Because these have multi language support, we need to do this inside the main component function so that we can use the translation hook. Add this code below the previous code:::

    export default function Fruits() {
        const { t } = useTranslation("admin");
        const columns = [
            columnHelper.accessor("id", {
                header: t("fruits.id"),
                cell: (info) => info.getValue(),
            }),
            columnHelper.accessor("name", {
                header: t("fruits.name"),
                cell: (info) => info.getValue(),
            }),
            columnHelper.accessor("color", {
                header: t("fruits.color"),
                cell: (info) => info.getValue(),
            }),
            columnHelper.accessor("price", {
                header: t("fruits.price"),
                cell: (info) => info.getValue(),
            }),
        ];
    }

``const { t } = useTranslation("admin");`` initializes the translation hook for the "admin" namespace, allowing us to use translated strings in our table headers. Each column is defined using ``columnHelper.accessor``, specifying the property of the ``FruitRead`` object to display, along with the header and cell rendering logic.

.. tip::
    Always add translations to the components and pages you create. LibU will be really sad if we end up with a frontend that only works in Swedish.

To display fruits, we need to fetch them from the backend API. We will use the ``useSuspenseQuery`` hook to do this. Add the following below the columns definitions, inside the ``Fruits`` function:::

    const { data, error } = useSuspenseQuery({
		...getAllFruitsOptions(),
	});

This fetches all the fruits from the backend API and puts it in the ``data`` variable. If there is an error during fetching, it will be stored in the ``error`` variable. 

.. note::
    A hook in React is a special function that lets you "hook into" React features from function components. They allow for things like state management (remembering values between renders) and side effects (performing actions like data fetching when the component renders or updates). 

We shall now define our table using a custom hook called ``useCreateTable``. Add this code below the previous code:::

    const table = useCreateTable({ data: data ?? [], columns });

This creates a table instance using the fetched data and the defined columns. The ``data ?? []`` syntax ensures that if ``data`` is undefined (e.g., while loading), an empty array is used instead to avoid errors.

Great! Now we can render the actual page. Add this at the bottom of the ``Fruits`` function:::

    return (
        <Suspense fallback={<LoadingErrorCard isLoading={true} />}>
            <div className="px-8 space-x-4">
                <h3 className="text-3xl py-3 font-bold text-primary">
                    {t("admin:fruits.page_title")}
                </h3>

                <p className="py-3">{t("admin:fruits.page_description")}</p>

                <AdminTable table={table}/>
            </div>
        </Suspense>
    );

This code renders the page content. We use a ``Suspense`` component to handle loading states, it will show ``LoadingErrorCard`` while data is being fetched. Inside, we have a header (h3) and a paragraph (p) that use translated strings. Finally, we render the ``AdminTable`` component, passing in our table instance to display the fruit data.

.. note::
    **What's this ``className`` stuff?** We are using a CSS framework called **Tailwind CSS** to style our components. The ``className`` attributes contain utility classes that apply specific styles, such as padding, font size, and colors. For example, ``px-8`` adds horizontal padding, ``text-3xl`` sets the text size to 3 times extra large, and ``text-primary`` applies the primary color defined in our theme. This is much easier than writing custom CSS for every component.

You should now be able to see the fruit admin page by navigating to ``http://localhost:3000/admin/fruits`` in your web browser, after having started the frontend server with the commands:::

    bun install
    bun run generate-api
    bun run dev

Since we haven't added any fruits yet, the page will show an empty table. The title and description should be visible, but will only show placeholder text since we have not added the translation keys we referenced yet.


Adding Fruits
-------------


Let's get started with adding the functionality to add new fruits. We will add a button above the table that opens a form for adding a new fruit. Create a new file in the same folder as ``page.tsx``, called ``FruitForm.tsx``. This file will contain the code for the form component. 

Imports
^^^^^^^

Start by adding the imports to the top of the file:::

    import { useState, useEffect } from "react";
    import { Button } from "@/components/ui/button";
    import {
        Dialog,
        DialogContent,
        DialogHeader,
        DialogTitle,
    } from "@/components/ui/dialog";
    import { useForm } from "react-hook-form";
    import {
        Form,
        FormControl,
        FormField,
        FormItem,
        FormLabel,
    } from "@/components/ui/form";
    import { Input } from "@/components/ui/input";
    import { zodResolver } from "@hookform/resolvers/zod";
    import { z } from "zod";
    import { useMutation, useQueryClient } from "@tanstack/react-query";
    import {
        createFruitMutation,
        getAllFruitsQueryKey,
    } from "@/api/@tanstack/react-query.gen";
    import { Plus } from "lucide-react";
    import { useTranslation } from "react-i18next";

There's not much to add here yet. Note the imports of ``zod``, which we will use for form validation (checking that the user input is correct) and ``createFruitMutation``, which we will use to send the new fruit data to the backend API.

Zod Schema
^^^^^^^^^^

Zod needs a schema to tell it how to validate the form data. Add this code below the imports:::

    const fruitSchema = z.object({
        name: z.string().min(1),
        color: z.string().min(1),
        price: z.number().min(0),
    });

Here we forbid empty names and colors, and we make sure the price is a non-negative number.

.. note::
    When using schema validation in the frontend, make sure it matches the validation rules in the backend. The backend API can be interacted with without using the website (e.g. using special tools like Postman), so the frontend should not be a layer of "security" but rather a way to improve user experience by catching errors early.

Component Logic
^^^^^^^^^^^^^^^

Now we define the component itself. We need to manage the state of the dialog (open/closed) and the form submission status. We also initialize the form hook using the schema we just created. Add this code below the schema:::

    export default function FruitForm() {
        const [open, setOpen] = useState(false);
        const [submitEnabled, setSubmitEnabled] = useState(true);
        const fruitForm = useForm<z.infer<typeof fruitSchema>>({
            resolver: zodResolver(fruitSchema),
            defaultValues: {
                name: "",
                color: "",
                price: 0,
            },
        });
        const { t } = useTranslation("admin");
        const queryClient = useQueryClient();

The ``useState(false)`` call creates a state variable called ``open`` initialized to ``false``, along with a function ``setOpen`` that we can use to update it. This controls whether the popup dialog is visible or not. We do the same for ``submitEnabled``, which tracks whether the submit button should be clickable. The ``useForm`` hook initializes the form logic. The ``resolver: zodResolver(fruitSchema)`` part is really important because it connects the Zod validation rules we wrote earlier to the form, so the form knows when data is invalid and can show appropriate error messages. We're gonna use queryClient later to refresh the fruit list after adding a new fruit.

Handling Data Submission
^^^^^^^^^^^^^^^^^^^^^^^^

To send data to the backend, we use a mutation. We also need a function to handle the form submission event. Add this inside the component:::

    const createFruit = useMutation({
		...createFruitMutation(),
		throwOnError: false,
		onSuccess: (data) => {
			queryClient.invalidateQueries({ queryKey: getAllFruitsQueryKey() });
			setOpen(false);
			setSubmitEnabled(true);
		},
		onError: (error) => {
			setSubmitEnabled(true);
		},
	});

The ``useMutation`` hook comes from React Query. While ``useQuery`` is for fetching data from the backend, ``useMutation`` is specifically for changing data. As you can see, we have defined ``onSuccess`` and ``onError`` handlers. If the mutation is successful, we invalidate the fruit list query so that it gets refetched with the new data, close the dialog, and re-enable the submit button. If there is an error, we just re-enable the submit button so the user can try again. After this, add the ``onSubmit`` function:::

    function onSubmit(values: z.infer<typeof fruitSchema>) {
        setSubmitEnabled(false);
        createFruit.mutate({
            body: {
                name: values.name,
                color: values.color,
                price: values.price,
            },
        });
    }

The ``onSubmit`` function is special because it's only called by the form library if all validation passes. As soon as the function runs, we immediately disable the submit button by calling ``setSubmitEnabled(false)``. This prevents the user from clicking the button multiple times while the request is being processed, which could otherwise create duplicate fruits. Then we can call the mutation we defined earlier with the proper data.

Resetting the Form
^^^^^^^^^^^^^^^^^^

When the user opens the dialog, we want to make sure the form is empty. We can use the ``useEffect`` hook to reset the form whenever the ``open`` state changes to true. Add this below the ``onSubmit`` function:::

    useEffect(() => {
        if (open) {
            fruitForm.reset({
                name: "",
                color: "",
                price: 0,
            });
        }
    }, [open, fruitForm]);

The ``useEffect`` hook is designed to run code in response to changes. The array at the end, ``[open, fruitForm]``, is called the dependency array. React will run the code inside the effect whenever any of these variables change. In this case, whenever the dialog opens (when ``open`` becomes true), we reset all the form fields to their default empty values. This helps clear the data from the previous fruit submission.

Rendering the Dialog Structure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Finally, we need to render the UI. We'll start with the button that opens the dialog and the basic structure of the form dialog itself. The ``Form`` component acts as a context provider for ``react-hook-form``, passing down all the necessary methods to the input fields we will add later. Don't worry about understanding every line of this code, most of it is just boilerplate.

Add this return statement at the end of the component:::

    return (
        <div className="p-3">
            <Button
                onClick={() => {
                    fruitForm.reset();
                    setOpen(true);
                    setSubmitEnabled(true);
                }}
            >
                <Plus />
                {t("fruits.create_fruit")}
            </Button>
            <Dialog open={open} onOpenChange={setOpen}>
                <DialogContent className="min-w-fit lg:max-w-7xl max-h-[80vh] overflow-y-auto">
                    <DialogHeader>
                        <DialogTitle>{t("fruits.create_fruit")}</DialogTitle>
                    </DialogHeader>
                    <hr />
                    <Form {...fruitForm}>
                        <form
                            onSubmit={fruitForm.handleSubmit(onSubmit)}
                            className="grid gap-x-4 gap-y-3 lg:grid-cols-2"
                        >
                            {/* Form fields will go here */}
                        </form>
                    </Form>
                </DialogContent>
            </Dialog>
        </div>
    );
    }

The ``Form`` component will contain all our form fields (like name, color and price) and handle most of the form logic for us so we don't need to worry about it. The ``Dialog`` component is controlled by the ``open`` state we defined earlier, so when we call ``setOpen(true)`` in the button's click handler, the dialog appears. Just like before, there is a lot of CSS styling via ``className`` attributes to make the dialog look nicer, you don't have to understand them.

.. note::
    The component we are writing essentially comes in two parts: the button that opens the dialog, and the dialog itself. You can see the button component at the top of the return statement above, with the dialog just below it. The dialog contains the form structure, which we will complete next. 

Adding Input Fields
^^^^^^^^^^^^^^^^^^^

Now we need to add the actual input fields inside the ``<form>`` tag. We use the ``FormField`` component to connect our inputs to the form state.

The ``FormField`` component takes a ``control`` prop (from our ``fruitForm`` hook) and a ``name`` prop (which must match a key in our Zod schema). The ``render`` prop is where the magic happens: it gives us a ``field`` object containing props like ``onChange``, ``onBlur``, and ``value``, which we spread onto our ``Input`` component. This automatically wires up validation and state management.

Replace the comment ``{/* Form fields will go here */}`` with the following code:::

                            <FormField
                                control={fruitForm.control}
                                name="name"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>{t("fruits.name")}</FormLabel>
                                        <FormControl>
                                            <Input
                                                placeholder={t("fruits.name")}
                                                {...field}
                                                value={field.value ?? ""}
                                            />
                                        </FormControl>
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={fruitForm.control}
                                name="color"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>{t("fruits.color")}</FormLabel>
                                        <FormControl>
                                            <Input
                                                placeholder={t("fruits.color")}
                                                {...field}
                                                value={field.value ?? ""}
                                            />
                                        </FormControl>
                                    </FormItem>
                                )}
                            />
                            <FormField
                                control={fruitForm.control}
                                name="price"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>{t("fruits.price")}</FormLabel>
                                        <FormControl>
                                            <Input
                                                type="number"
                                                step="0.01"
                                                placeholder={t("fruits.price")}
                                                {...field}
                                                value={field.value ?? ""}
                                                onChange={(e) =>
                                                    field.onChange(Number.parseFloat(e.target.value))
                                                }
                                            />
                                        </FormControl>
                                    </FormItem>
                                )}
                            />
                            <div className="space-x-2 lg:col-span-2 lg:grid-cols-subgrid">
                                <Button
                                    type="submit"
                                    disabled={!submitEnabled}
                                    className="w-32 min-w-fit"
                                >
                                    {t("fruits.save")}
                                </Button>
                            </div>

The ``render={({ field }) => ...}`` pattern might look a bit complex at first. It's what's called a "render prop" in React. Essentially, it's a function that returns JSX which can later be shown. The form library calls this function and passes it the ``field`` object, which contains everything the input needs to work correctly with the form. The syntax ``{...field}`` is JavaScript spread syntax, which is a shortcut for taking all properties inside ``field`` (like ``onChange``, ``value``, ``onBlur``) and adding them as props to the ``<Input />`` component. Without this shortcut, we would have to write ``onChange={field.onChange} value={field.value} onBlur={field.onBlur}`` and so on, which gets repetitive quickly. Pay special attention to the ``price`` field's ``onChange`` handler. HTML inputs with ``type="number"`` actually return strings (like "10.5") rather than actual numbers, even though they look like numbers. Since our Zod schema expects a real number, we need to override the default ``onChange`` behavior to parse the string into a float using ``Number.parseFloat`` before saving it to the form state.


Phew! Our form component is now complete. Before we can use it, we need to actually add it to our fruit admin page.


Using the Form Component
^^^^^^^^^^^^^^^^^^^^^^^^

Go back to the ``page.tsx`` file we created earlier. We need to import the ``FruitForm`` component and add it above the table. Add this import at the top with the other imports:::

    import FruitForm from "./FruitForm";

Now, add the ``<FruitForm />`` component just above the ``<AdminTable />`` component in the return statement:::

                <FruitForm />
                <AdminTable table={table}/>

That's it! You should now be able to open the fruit admin page in your web browser, click the "Create Fruit" button, fill out the form, and submit it. The new fruit should appear in the table after submission. If you get any errors or something doesn't work, just ask a su-perman and they will try to help you.


Next Steps
----------

Congratulations on completing the fruit admin page tutorial! You've learned how to create a new admin page, fetch data from the backend, display it in a table, and add a form for creating new entries. This is a solid foundation for building more complex admin pages in the future. As mentioned at the start, when you actually get to building new features, it's often faster to copy and modify existing code rather than writing everything from scratch. 

For now, there are some things you can optionally add to improve the page:

- Add translations for all the translation keys we used in the page and form components. You can find the translation files in ``src/locales/en/admin.json`` and ``src/locales/sv/admin.json``. Add something like this to the bottom of both files:
..

::

    "fruits": {
        "id": "ID",
        "name": "Name",
        "color": "Color",
        "price": "Price",
        "page_title": "Fruit Management",
        "page_description": "Manage fruits in the system",
        "create_fruit": "Create Fruit",
        "save": "Save"
    }

- Implement editing and deleting fruits. You can look at other admin pages in the codebase for examples of how to do this. Essentially, you will need to find the right API mutations and add support for clicking the table to edit or delete entries.
- Style the page further using Tailwind CSS to make it look nicer.
- Add error handling to show messages if something goes wrong during data fetching or submission. We tend to use toast notifications for this. Again, you can look at other admin pages for examples.
