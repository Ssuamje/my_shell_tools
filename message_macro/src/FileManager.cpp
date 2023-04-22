/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   FileManager.cpp                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sanan <sanan@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/03/22 22:36:16 by sanan             #+#    #+#             */
/*   Updated: 2023/04/14 12:04:04 by sanan            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/FileManager.hpp"

std::ifstream FileManager::_ifs;
std::ofstream FileManager::_ofs;

FileManager::FileManager() {

}

FileManager::FileManager(std::string file) {
	this->_file = file;
}

FileManager::~FileManager() {

}

void		FileManager::setFile(std::string file) {
	this->_file = file;
}

int			FileManager::isFileValid(std::string file) {
	_ifs.open(file);
	if (_ifs.is_open() == false) {
		_ifs.clear();
		_ifs.close();
		return (false);
	}
	_ifs.clear();
	_ifs.close();
	return (true);
}

std::string FileManager::extractStringFromFile() {
	std::string	ret;
	std::string	line;

	_ifs.open(this->_file);
	if (_ifs.is_open() == false) {
		std::cout << "ifstream.open() has failed!" << std::endl;
		exit(EXIT_FAILURE);
	}
	while (std::getline(_ifs, line)) {
		ret += line;
		if (_ifs.eof() == false || line.back() == '\n')
			ret += std::string("\n");
	}
	if (_ifs.bad()) {
		std::cout <<
		"ifstream is broken!" << std::endl;
		exit(EXIT_FAILURE);
	}
	_ifs.close();
	return (ret);
}

void		FileManager::putStringToFile(std::string str, std::string filename) {
	_ofs.open(this->_file + "_" + filename);
	if (_ofs.is_open() == false)
		exit(EXIT_FAILURE);
	_ofs << str;
	_ofs.close();
}