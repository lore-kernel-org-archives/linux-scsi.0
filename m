From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.9-rc2-mm2: 3ware card info not in /proc/scsi
Date: Thu, 23 Sep 2004 19:43:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040923194322.78fb1c59.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:15029 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S267685AbUIXCpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Sep 2004 22:45:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Adam Radford <aradford@amcc.com>
Cc: linux-scsi@vger.kernel.org


Did this get broken?

Begin forwarded message:

Date: Thu, 23 Sep 2004 11:09:06 -0500
From: Glenn Johnson <gjohnson@srrc.ars.usda.gov>
To: linux-kernel@vger.kernel.org
Subject: 2.6.9-rc2-mm2: 3ware card info not in /proc/scsi


I have a 3Ware-7500 series card.  I was trying the 2.6.9-rc2-mm2 kernel
and discovered that the 3dmd utility was not working.  A little poking
around revealed that the cause was because the 3Ware directory was not
in /proc/scsi, even though I have CONFIG_SCSI_PROC_FS=y in my config
file.  The 3dmd utility works fine with mainline 2.6.9-rc2 and it worked
with the 2.6.8-mm series of kernels.  Those kernels have a 3w-xxxx
directory in /proc/scsi.

Thanks.

-- 
Glenn Johnson

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
