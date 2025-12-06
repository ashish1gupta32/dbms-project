package com.sarika.silkhouse;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.sarika.silkhouse.dao.Userdao;
import com.sarika.silkhouse.model.User;

@Controller
public class LoginController {

	@Autowired
	public Userdao userdao;

	@RequestMapping(value = { "/home", "/" })
	public String welcome(Model model, HttpServletRequest request) {
		model.addAttribute("name", "Home Page");
		model.addAttribute("description", "Page yet to be completed!");
		// System.out.println(request.getUserPrincipal().getName());
		if (request.getUserPrincipal() == null)
			return "user_home";
		String str1 = "ashishadmin";
		String str = request.getUserPrincipal().getName();
		if (str1.equals(str)) {
			return "admin";
		} else {
			return "user_home";
		}

	}

	@RequestMapping("/user")
	public String user(Model model, Principal principal) {

		String loggedInUserName = principal.getName();
		model.addAttribute("user", loggedInUserName);
		model.addAttribute("name", "Spring Security USER Custom Login Demo");
		model.addAttribute("description", "Protected page for user !");
		return "user";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(ModelMap model) {

		return "login";

	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(ModelMap model) {
		// model.addAttribute("message",
		// "You have successfully logged off from application !");

		return "login";

	}

	@RequestMapping(value = "/loginError", method = RequestMethod.GET)
	public String loginError(ModelMap model) {
		model.addAttribute("error", "true");
		return "login";

	}

	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String register(Model model) {

		User user = new User();
		model.addAttribute("user", user);

		return "register";
	}

	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String registerProcess(@Valid @ModelAttribute("user") User user, BindingResult result, Model model) {

		if (result.hasErrors()) {
			return "register";
		} else {
			if (!user.getPassword().equals(user.getMpassword())) {
				model.addAttribute("error", "passwords dont match");
				return "register";
			}
			if (userdao.getUser(user.getUsername()) != null) {
				model.addAttribute("error", "username exists");
				return "register";
			}
			if (userdao.getNumber(user.getPhone()) != null) {
				model.addAttribute("error", "mobile number already exists");
				return "register";
			}
			String str = user.getEmail();
			if (str.length() > 100) {
				model.addAttribute("error", "email length is very large");
				return "register";
			}
			userdao.saveOrUpdate(user);
			return "registersuccesful";
		}
	}

	@RequestMapping(value = "/user/products")
	public String checker(Model model, Principal principal) {
		String user = principal.getName();
		model.addAttribute("user", user);
		model.addAttribute("product", "product");
		return "product";
	}

	@RequestMapping("/contact")
	public String contact() {
		return "contact";
	}

}
