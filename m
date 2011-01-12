From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: build failure of drivers/scsi/gdth.c
Date: Wed, 12 Jan 2011 08:39:19 -0800
Message-ID: <20110112083919.494a7404.rdunlap@xenotime.net>
References: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:51496 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755196Ab1ALQjY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 11:39:24 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2011 08:39:19 -0800
In-Reply-To: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 12 Jan 2011 12:29:19 +0200 Or Gerlitz wrote:

> I got into that with 2.6.37 after adding some dynamic debug
> configs (I can send the compressed .config if needed)
> 
> The same/similar problem happens also for the few more places
> which use LINUX_VERSION_CODE
> 
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CC [M]  drivers/scsi/gdth.o
> drivers/scsi/gdth.c: In function gdth_ioctl:
> drivers/scsi/gdth.c:4510: error: expected expression before >> token
> drivers/scsi/gdth.c:4511: error: expected expression before >> token
> drivers/scsi/gdth.c:4512: error: invalid lvalue in unary
> make[2]: *** [drivers/scsi/gdth.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> --

I've never seen this problem in 2.6.37 AFAIK and I have 2.6.37 gdth.o and gdth.ko
built on my system now.

How can I reproduce this?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
