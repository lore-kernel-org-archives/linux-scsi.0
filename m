From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: MODULE_VERSION for scsi drivers
Date: Mon, 26 Apr 2004 21:15:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <32805.4.5.45.142.1083039354.squirrel@www.osdl.org>
References: <20040427040923.GA9901@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:41951 "EHLO fire-2.osdl.org")
	by vger.kernel.org with ESMTP id S262019AbUD0EP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2004 00:15:57 -0400
In-Reply-To: <20040427040923.GA9901@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org

> Now that the MODULE_VERSION() macro is in 2.6, I'd love to see all
> modules implement it.  So before I go touch all the SCSI drivers, I
> thought I'd bounce this off the list.
>
> There are a few drivers with version strings that look like this:
>  #define VERSION "1.10 (23/01/2003 2.5.57)"
>
> In the new world order, I think they need to look more like this:
>  #define DRV_VERSION "2.5.57"
>  #define DRV_DATE "23/01/2003"
> and print both strings if it's interesting to do so, but the date
> stays out of the MODULE_VERSION(DRV_VERSION).
>
> Thoughts?  Patch below against Linus's BK-cur covers a the a* drivers,
> plus a few I care specifically about.

What's the purpose of the
MODULE_VERSION(""):
instances?  (e.g.:)


> ===== drivers/scsi/a2091.c 1.13 vs edited ====---
> 1.13/drivers/scsi/a2091.c	Sat Sep 27 10:17:28 2003
> +++ edited/drivers/scsi/a2091.c	Mon Apr 26 22:21:06 2004
> @@ -258,3 +258,4 @@
>  }
>
>  MODULE_LICENSE("GPL");
> +MODULE_VERSION("");

~Randy

