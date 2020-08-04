package com.blog.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.blog.entity.Blog;
import com.blog.entity.PageBean;
import com.blog.service.BlogService;
import com.blog.util.PageUtil;
import com.blog.util.StringUtil;

/**
 * 首页
 *
 */
@Controller
public class IndexController {

	@Resource
	private BlogService blogService;

	@RequestMapping({ "/index" })
	public ModelAndView index(@RequestParam(value = "page", required = false) String page,
			@RequestParam(value = "typeId", required = false) String typeId,
			@RequestParam(value = "releaseDateStr", required = false) String releaseDateStr,
			HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		mav.addObject("title", "个人博客系统");
		// page为空默认查询第1页
		if (StringUtil.isEmpty(page)) {
			page = "1";
		}
		// 翻页（每页10篇博客）
		PageBean pageBean = new PageBean(Integer.parseInt(page), 10);
		Map<String, Object> map = new HashMap<>();
		map.put("start", pageBean.getStart());
		map.put("size", pageBean.getPageSize());
		map.put("typeId", typeId); // 加入类型查询
		map.put("releaseDateStr", releaseDateStr);// 加入日期查询
		// 查询blog列表
		List<Blog> list = blogService.list(map);

		StringBuffer param = new StringBuffer();
		// 存在日期查询
		if (StringUtil.isNotEmpty(typeId)) {
			param.append("typeId=" + typeId + "&");
		}
		// 存在类型查询
		if (StringUtil.isNotEmpty(releaseDateStr)) {
			param.append("releaseDateStr=" + releaseDateStr + "&");
		}
		mav.addObject("mainPage", "foreground/blog/list.jsp"); // 博客列表页面
		String pageCode = PageUtil.genPagination(request.getContextPath() + "/index.html", blogService.getTotal(map),
				Integer.parseInt(page), 10, param.toString());
		mav.addObject("pageCode", pageCode);
		mav.addObject("blogList", list);
		return mav;
	}
}
