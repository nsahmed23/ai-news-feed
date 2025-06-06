# Cursor + Claude Code Workflow Guide

## Overview
This guide explains how to effectively use Cursor Max alongside Claude Code for maximum productivity.

## The Optimal Workflow

### 1. Use Claude Code for Initial Generation
- Large module creation
- Complete Terraform modules
- Full Python classes
- Complex configurations

### 2. Use Cursor for Enhancement
- Security improvements
- Cost optimization
- Error handling
- Documentation
- Unit tests

## Cursor Keyboard Shortcuts

- `Ctrl+K`: Quick inline edits
  - Example: "optimize this for AWS cost"
  - Example: "add error handling for throttling"
  
- `Ctrl+L`: Open AI chat panel
  - Example: "explain this Terraform configuration"
  - Example: "what security issues do you see?"
  
- `Ctrl+I`: Generate code from comment
  - Write: `# function to parse RSS feed with retry logic`
  - Press Ctrl+I to generate
  
- `Tab`: Accept AI suggestion
- `Esc`: Reject suggestion

## Practical Examples

### Example 1: Terraform Security Review
```hcl
# After pasting Terraform from Claude Code:
# 1. Select the resource block
# 2. Press Ctrl+K
# 3. Type: "add security best practices"