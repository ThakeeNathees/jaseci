# React-Style Components

Build reusable UI components with JSX syntax.

> **Prerequisites**
>
> - Completed: [Project Setup](setup.md)
> - Time: ~30 minutes

---

## Basic Component

```jac
cl {
    def:pub Greeting(props: dict) -> Any {
        return <h1>Hello, {props.name}!</h1>;
    }

    def:pub app() -> Any {
        return <div>
            <Greeting name="Alice" />
            <Greeting name="Bob" />
        </div>;
    }
}
```

**Key points:**

- Components are functions returning JSX
- `def:pub` exports the component
- `props` contains passed attributes
- Self-closing tags: `<Component />`

---

## JSX Syntax

### HTML Elements

```jac
cl {
    def:pub MyComponent() -> Any {
        return <div className="container">
            <h1>Title</h1>
            <p>Paragraph text</p>
            <a href="/about">Link</a>
            <img src="/logo.png" alt="Logo" />
        </div>;
    }
}
```

**Note:** Use `className` not `class` (like React).

### JavaScript Expressions

```jac
cl {
    def:pub MyComponent() -> Any {
        name = "World";
        items = [1, 2, 3];

        return <div>
            <p>Hello, {name}!</p>
            <p>Sum: {1 + 2 + 3}</p>
            <p>Items: {len(items)}</p>
        </div>;
    }
}
```

Use `{ }` to embed any Jac expression.

---

## Conditional Rendering

### Ternary Operator

```jac
cl {
    def:pub Status(props: dict) -> Any {
        return <span>
            {("Active" if props.active else "Inactive")}
        </span>;
    }
}
```

### Logical AND

```jac
cl {
    def:pub Notification(props: dict) -> Any {
        return <div>
            {props.count > 0 and <span>You have {props.count} messages</span>}
        </div>;
    }
}
```

### If Statement

```jac
cl {
    def:pub UserGreeting(props: dict) -> Any {
        if props.isLoggedIn {
            return <h1>Welcome back!</h1>;
        }
        return <h1>Please sign in</h1>;
    }
}
```

---

## Lists and Iteration

```jac
cl {
    def:pub TodoList(props: dict) -> Any {
        return <ul>
            {props.items.map(lambda item: any -> Any {
                return <li key={item.id}>{item.text}</li>;
            })}
        </ul>;
    }

    def:pub app() -> Any {
        todos = [
            {"id": 1, "text": "Learn Jac"},
            {"id": 2, "text": "Build app"},
            {"id": 3, "text": "Deploy"}
        ];

        return <TodoList items={todos} />;
    }
}
```

**Important:** Always provide a `key` prop for list items.

---

## Event Handling

### Click Events

```jac
cl {
    def:pub Button() -> Any {
        def handle_click() -> None {
            print("Button clicked!");
        }

        return <button onClick={lambda -> None { handle_click(); }}>
            Click me
        </button>;
    }
}
```

### Input Events

```jac
cl {
    def:pub SearchBox() -> Any {
        has query: str = "";

        return <input
            type="text"
            value={query}
            onChange={lambda e: any -> None { query = e.target.value; }}
            placeholder="Search..."
        />;
    }
}
```

### Form Submit

```jac
cl {
    def:pub LoginForm() -> Any {
        has username: str = "";
        has password: str = "";

        def handle_submit(e: any) -> None {
            e.preventDefault();
            print(f"Login: {username}");
        }

        return <form onSubmit={lambda e: any -> None { handle_submit(e); }}>
            <input
                value={username}
                onChange={lambda e: any -> None { username = e.target.value; }}
            />
            <input
                type="password"
                value={password}
                onChange={lambda e: any -> None { password = e.target.value; }}
            />
            <button type="submit">Login</button>
        </form>;
    }
}
```

---

## Component Composition

### Children

```jac
cl {
    def:pub Card(props: dict) -> Any {
        return <div className="card">
            <div className="card-header">{props.title}</div>
            <div className="card-body">{props.children}</div>
        </div>;
    }

    def:pub app() -> Any {
        return <Card title="Welcome">
            <p>This is the card content.</p>
            <button>Action</button>
        </Card>;
    }
}
```

### Nested Components

```jac
cl {
    def:pub Header() -> Any {
        return <header>
            <h1>My App</h1>
            <Nav />
        </header>;
    }

    def:pub Nav() -> Any {
        return <nav>
            <a href="/">Home</a>
            <a href="/about">About</a>
        </nav>;
    }

    def:pub Footer() -> Any {
        return <footer>© 2024</footer>;
    }

    def:pub app() -> Any {
        return <div>
            <Header />
            <main>Content here</main>
            <Footer />
        </div>;
    }
}
```

---

## Separate Component Files

### Header.cl.jac

```jac
# No cl { } needed for .cl.jac files

def:pub Header(props: dict) -> Any {
    return <header>
        <h1>{props.title}</h1>
    </header>;
}
```

### main.jac

```jac
cl {
    import from "./Header.cl.jac" { Header }

    def:pub app() -> Any {
        return <div>
            <Header title="My App" />
            <main>Content</main>
        </div>;
    }
}
```

---

## TypeScript Components

You can use TypeScript components:

### Button.tsx

```typescript
interface ButtonProps {
  label: string;
  onClick: () => void;
}

export function Button({ label, onClick }: ButtonProps) {
  return <button onClick={onClick}>{label}</button>;
}
```

### main.jac

```jac
cl {
    import from "./Button.tsx" { Button }

    def:pub app() -> Any {
        return <Button
            label="Click me"
            onClick={lambda -> None { print("Clicked!"); }}
        />;
    }
}
```

---

## Styling Components

### Inline Styles

```jac
cl {
    def:pub StyledBox() -> Any {
        return <div style={{
            "backgroundColor": "#f0f0f0",
            "padding": "20px",
            "borderRadius": "8px",
            "boxShadow": "0 2px 4px rgba(0,0,0,0.1)"
        }}>
            Styled content
        </div>;
    }
}
```

### CSS Classes

```jac
cl {
    import ".styles.css";

    def:pub app() -> Any {
        return <div className="container">
            <h1 className="title">Hello</h1>
        </div>;
    }
}
```

```css
/* .styles.css */
.container {
    max-width: 800px;
    margin: 0 auto;
}
.title {
    color: #333;
}
```

---

## Key Takeaways

| Concept | Syntax |
|---------|--------|
| Define component | `def:pub Name(props: dict) -> Any { }` |
| JSX element | `<div className="x">content</div>` |
| Expression | `{expression}` |
| Event handler | `onClick={lambda -> None { ... }}` |
| List rendering | `{items.map(lambda x -> Any { <li>{x}</li> })}` |
| Conditional | `{condition ? <A /> : <B />}` |
| Children | `{props.children}` |
| Import component | `import from "./File.cl.jac" { Component }` |

---

## Next Steps

- [State Management](state.md) - Reactive state with `has`
- [Backend Integration](backend.md) - Connect to walkers
