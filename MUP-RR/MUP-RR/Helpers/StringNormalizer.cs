using System;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace MUP_RR.Helpers
{
    public static class StringNormalizer
    {
        public static string Substring(string text, int length)
        {
            return text.Substring(0, Math.Min(length, text.Length));
        }

        public static string[] LettersDic =
        {
            "[aåâäàáã]",
            "[eêëèé]",
            "[iíìîï]",
            "[oøöóòôõ]",
            "[uüúùû]",
            "[cç]"
        };

        public static string Normalize(string searchSentence)
        {
            //remove double spaces end space at begining and ending
            RegexOptions options = RegexOptions.None;
            Regex regex = new Regex("[ ]{2,}", options);
            searchSentence = regex.Replace(searchSentence, " ").Trim();

            searchSentence = searchSentence.ToLower();
            String result = "";

            for (int i = 0; i < searchSentence.Length; i++)
            {
                //Problema de palavras com acentos
                string originalLetter = "" + searchSentence.ElementAt(i);
                string newLetter = originalLetter;
                foreach (string expression in LettersDic)
                {
                    if (expression.Contains(originalLetter))
                    {
                        newLetter = expression;
                    }
                }
                //Problema de palavras juntas
                if (originalLetter.Equals(" "))
                    newLetter = "( .+)? ";
                result += newLetter;
            }
            return "(.+ )?" + result + "( .+)?";
        }

        public static string FirstAndLastName(string name)
        {
            if (string.IsNullOrEmpty(name))
                return "";

            var names = name.Split(Array.Empty<char>(), StringSplitOptions.RemoveEmptyEntries);
            if (names.Length < 2)
                return name;

            return $"{names.ElementAt(0)} {names.Last()}";
        }

        public static string RemoveDiacritics(string text)
        {
            var normalizedString = text.Normalize(NormalizationForm.FormD);
            var stringBuilder = new StringBuilder();

            foreach (var c in normalizedString)
            {
                var unicodeCategory = CharUnicodeInfo.GetUnicodeCategory(c);
                if (unicodeCategory != UnicodeCategory.NonSpacingMark)
                {
                    stringBuilder.Append(c);
                }
            }

            return stringBuilder.ToString().Normalize(NormalizationForm.FormC);
        }

        public static string CreateSlug(string text)
        {
            text = text.ToLower();
            text = RemoveDiacritics(text);
            text = text.Replace(" and ", " ");
            text = text.Replace(" e ", " ");
            text = text.Replace(" de ", " ");
            text = text.Replace("de ", " ");
            RegexOptions options = RegexOptions.None;
            Regex reg = new Regex("[*'\"_&#^@-]");
            text = reg.Replace(text, string.Empty);
            Regex regex = new Regex("[ ]{1,}", options);
            return regex.Replace(text, "-").ToLower();
        }

        public static string GeneratePathFromSequenceNumber(int iD)
        {
            string idString = GenerateSequenceNumber(iD);
            return $"{idString.Substring(0, 3)}\\{idString.Substring(3, 3)}";
        }

        public static string GenerateFileNameFromSequenceNumber(int iD)
        {
            string idString = GenerateSequenceNumber(iD);
            return $"{idString.Substring(6, 3)}";
        }

        public static string GenerateSequenceNumber(int iD)
        {
            string idString = iD.ToString();
            while (idString.Length < 9)
            {
                idString = "0" + idString;
            }
            return idString;
        }
    }
}