From: Mark Haverkamp <markh@osdl.org>
Subject: Re: (PATCH) The megaraid driver v2.00.5 for kernel 2 .4.22-prex-ac1
Date: 25 Jul 2003 07:28:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059143309.2756.5.camel@markh1.pdx.osdl.net>
References: <200307250605.PAA11284@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4288 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S272121AbTGYONl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 10:13:41 -0400
In-Reply-To: <200307250605.PAA11284@toshiba.co.jp>
List-Id: linux-scsi@vger.kernel.org
To: "Tomita, Haruo" <haruo.tomita@toshiba.co.jp>
Cc: Matthew Wilcox <willy@debian.org>, Atul Mukker <atulm@lsil.com>, Matt Domsch <Matt_Domsch@Dell.com>, linux-megaraid-devel@Dell.com, linux-scsi <linux-scsi@vger.kernel.org>, "Tomita, Haruo" <htomita@pcs.pc.ome.toshiba.co.jp>

On Thu, 2003-07-24 at 23:04, Tomita, Haruo wrote:
> Dear all, 
> 
> 	Many Thanks!!
> 
> Finally,  I created the patch of the megaraid driver v2.00.5
> for kernel 2 .4.22-prex-ac1. Here is my patch codes.
> 
> Thanks again,
> Haruo

I think that your mailer broke some of the long lines


> === patch-mr2005-0724 of megaraid v2.00.5 driver for kernel 2.4.22  ===
> 
> diff -Nru linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c
> linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c

These next two line got broken

> --- linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c	2003-07-24 10:27:17.
> 000000000 +0900
> +++ linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c	2003-07-24 12:38:36.
> 000000000 +0900

And some of the MODULE_PARM_DESC lines:


here

> +MODULE_PARM_DESC(max_commands, "Maximum number of commands which can be
> issued to a single controller (default=MAX_COMMANDS=126)");


and here

>  MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be
> issued to a single LUN (default=DEF_CMD_PER_LUN=63)");


-- 
Mark Haverkamp <markh@osdl.org>

