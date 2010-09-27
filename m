From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
Date: Mon, 27 Sep 2010 09:39:12 -0700
Message-ID: <4CA0C8B0.9020209@gmail.com>
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com> <20100927151005.GC11086@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100927151005.GC11086@tuxdriver.com>
Sender: linux-ide-owner@vger.kernel.org
To: "John W. Linville" <linville@tuxdriver.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Finn Thain <fthain@telegraphics.com.au>, Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>, Dimitry Torokhov <dmitry.torokhov@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 09/27/2010 08:10 AM, John W. Linville wrote:
> On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
>> Below is an updated patch from the original fixing broken web addresses in the kernel.
>> Thanks for all the help and info on this to everybody..
>> Hopefully I didnt miss any of them(if so let me know, and I'll resend).
>
> Changing a URL for a relocated page is one thing, but removing links
> isn't necessarily a great idea.  Even if the site is technically
> gone, it may be possible to find information e.g through the Internet
> Archive Wayback Machine.
>
>> diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
>> index e8e2d0f..ba10b07 100644
>> --- a/drivers/net/wireless/orinoco/main.c
>> +++ b/drivers/net/wireless/orinoco/main.c
>> @@ -17,7 +17,6 @@
>>    *
>>    * Portions based on wvlan_cs.c 1.0.6, Copyright Andreas Neuhaus<andy
>>    * AT fasta.fh-dortmund.de>
>> - *      http://www.stud.fh-dortmund.de/~andy/wvlan/
>>    *
>>    * The contents of this file are subject to the Mozilla Public License
>>    * Version 1.1 (the "License"); you may not use this file except in
>
> http://web.archive.org/web/20070716051348/http://www.stud.fh-dortmund.de/~andy/wvlan/
>

most of the urls that are not removed that are still broken work with 
the wayback machine..(from what I remember this one would give me a 
server error(reason for removing), but it doesn't look so).

Thanks for this, I'll change that up.

Justin P. Mattock
