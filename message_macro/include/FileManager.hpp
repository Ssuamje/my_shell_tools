/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   FileManager.hpp                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sanan <sanan@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/03/22 22:35:23 by sanan             #+#    #+#             */
/*   Updated: 2023/04/14 11:59:09 by sanan            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */


#ifndef FILEMANAGER_HPP
#define FILEMANAGER_HPP

# include <fstream>
# include <iostream>

class FileManager {
	private:
	static std::ofstream	_ofs;
	static std::ifstream	_ifs;
	std::string 			_file;

	public:
	FileManager();
	FileManager(std::string file);
	~FileManager();
	int			isFileValid(std::string file);
	void		setFile(std::string file);
	std::string	extractStringFromFile();
	void		putStringToFile(std::string str, std::string filename);
};

#endif