From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] drivers/scsi/dpti.h: remove kernel 2.2 #if's
Date: Sat, 02 Apr 2005 07:49:38 -0600
Message-ID: <1112449778.5786.7.camel@mulgrave>
References: <20050327143421.GF4285@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:53184 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261487AbVDBNuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Apr 2005 08:50:50 -0500
In-Reply-To: <20050327143421.GF4285@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-03-27 at 16:34 +0200, Adrian Bunk wrote:
> This patch removes #if's for kernel 2.2 .

this one looks like it's not quite complete:

> -#ifndef LINUX_VERSION_CODE
>  #include <linux/version.h>
> -#endif

Once there are no more KERNEL_VERSION dependencies in a file, it's
inclusion of linux/version.h can be removed also (and that should
prevent it getting rebuilt every time the kernel version changes).

So it looks like there's an additional KERNEL_VERSION to remove in
dpt/dpti_i2o.h version.h includes in dpti_i2o.h and dpt_i2o.c

Then when you have a final patch, could you cc Markus Lidel
<Markus.Lidel@shadowconnect.com> and  

Mark_Salyzyn@adaptec.com

Thanks,

James


