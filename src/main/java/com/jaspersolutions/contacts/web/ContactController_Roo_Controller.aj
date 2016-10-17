// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.jaspersolutions.contacts.web;

import com.jaspersolutions.contacts.domain.Contact;
import com.jaspersolutions.contacts.domain.ContactType;
import com.jaspersolutions.contacts.web.ContactController;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect ContactController_Roo_Controller {
    
    @RequestMapping(params = "form", produces = "text/html")
    public String ContactController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Contact());
        return "contacts/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String ContactController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("contact", Contact.findContact(id));
        uiModel.addAttribute("itemId", id);
        return "contacts/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String ContactController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, @RequestParam(value = "sortFieldName", required = false) String sortFieldName, @RequestParam(value = "sortOrder", required = false) String sortOrder, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("contacts", Contact.findContactEntries(firstResult, sizeNo, sortFieldName, sortOrder));
            float nrOfPages = (float) Contact.countContacts() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("contacts", Contact.findAllContacts(sortFieldName, sortOrder));
        }
        return "contacts/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String ContactController.update(@Valid Contact contact, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, contact);
            return "contacts/update";
        }
        uiModel.asMap().clear();
        contact.merge();
        return "redirect:/contacts/" + encodeUrlPathSegment(contact.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String ContactController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Contact.findContact(id));
        return "contacts/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String ContactController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Contact contact = Contact.findContact(id);
        contact.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/contacts";
    }
    
    void ContactController.populateEditForm(Model uiModel, Contact contact) {
        uiModel.addAttribute("contact", contact);
        uiModel.addAttribute("contacttypes", Arrays.asList(ContactType.values()));
    }
    
    String ContactController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}