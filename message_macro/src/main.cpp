/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: sanan <sanan@student.42seoul.kr>           +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/03/22 22:34:18 by sanan             #+#    #+#             */
/*   Updated: 2023/04/14 12:02:32 by sanan            ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/FileManager.hpp"
#include <iostream>

std::string replaceString(std::string origin, std::string from, std::string to) {
    std::string		result;
    size_t			start_pos = 0;
    size_t			pos;

    while ((pos = origin.find(from, start_pos)) != std::string::npos) {
        result += origin.substr(start_pos, pos - start_pos) + to;
        start_pos = pos + from.length();
    }
    result += origin.substr(start_pos);
	return (result);
}

int main() {
	FileManager		fm;
	std::string		fTemplate;
	std::string		extract;
	std::string		delimiter;
	std::string		toReplace;

	std::cout << "Put template text filename." << std::endl;
	std::getline(std::cin, fTemplate);
	if (fm.isFileValid(fTemplate) == false)
		return (EXIT_FAILURE);
	fm.setFile(fTemplate);
	std::cout << "Put delimiter." << std::endl;
	std::getline(std::cin, delimiter);
	while (true) {
		std::cout << "Put word to replace delimiter." << std::endl;
		std::getline(std::cin, toReplace);
		extract = fm.extractStringFromFile();
		extract = replaceString(extract, delimiter, toReplace);
		fm.putStringToFile(extract, toReplace);
		system("clear");
	}
}
