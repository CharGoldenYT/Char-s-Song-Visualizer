package sys.logger;

import sys.logger.AnsiColors;
import sys.logger.Level;

class LogTools
{
    public static inline function levelToString(level:Level):String
    {
        switch (level)
        {
            case INFO:
                return AnsiColors.LightPurple + '[  INFO    ]';
            case WARNING:
                return AnsiColors.LightYellow + '[  WARNING ]';
            case ERROR:
                return AnsiColors.Error + '[  ERROR   ]';
            default:
                return '[  MISC    ]';
        }
    }
}