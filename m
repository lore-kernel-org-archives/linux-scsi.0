From: "erich" <erich@areca.com.tw>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Thu, 3 Feb 2005 12:33:37 +0800
Message-ID: <003f01c509a9$87913290$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Received: from 220-130-178-142.HINET-IP.hinet.net ([220.130.178.142]:34804
	"EHLO server-areca.rd.areca.com.tw") by vger.kernel.org with ESMTP
	id S262597AbVBCEdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 23:33:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Hi,Andrew Morton

Thanks for your doing.
ARECA Linux RAID driver need to support old linux kerenel version.
There are a lot of  NAS RAID STORAGE SYSTEM development worker still use it
at old linux kernel.
Maybe I need to released one package that as cleanly as look like a Linux
driver :) modern times :( .

Best Regards
Erich Chen

----- Original Message ----- 
From: "Andrew Morton" <akpm@osdl.org>
To: "erich" <erich@areca.com.tw>
Cc: <linux-scsi@vger.kernel.org>
Sent: Thursday, February 03, 2005 10:08 AM
Subject: Re: About ARECA RAID driver for Linux i386/x86-64


> "erich" <erich@areca.com.tw> wrote:
> >
> > I have contact with Andrew Morton about ARECA RAID Linux scsi driver
release
> >  issue.
> >  I hope this package is as look like a Linux driver.
>
> No, it doesn't look anything like a Linux driver :(
>
> I fed the patch through scripts/Lindent.  There's a copy at
>
http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
>  I'll include it -mm kernels.
>
> From a very quick look, I'd say that the driver needs quite a bit of work:
>
> - Remove Documentation/scsi/arcmsr.txt - none of it is relevant
>
> - Use named structure initialisers:
>
> struct foo bar = {
> .name1 = value1,
> .name2 = value2,
> };
>
> - Remove all the LINUX_VERSION_CODE tests
>
> - The kernel thread stopping/starting stuff is old fashioned.  Use the
>   kthread API.
>
> - I suspect it is using old-fashioned SCSI APIs too.
>
>

