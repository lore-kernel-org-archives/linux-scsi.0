From: Tore Anderson <tore@linpro.no>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Mon, 05 May 2008 09:48:52 +0200
Message-ID: <481EBBE4.5000005@linpro.no>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no> <20080429211655.GA72811@plap4.qlogic.org> <4817970A.4030807@linpro.no> <20080429222947.GE72811@plap4.qlogic.org> <48182E8F.6000009@linpro.no> <20080430171810.GC80852@n6016av4ptjbf1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:52220 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYEEHsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 03:48:54 -0400
In-Reply-To: <20080430171810.GC80852@n6016av4ptjbf1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Andrew,

* Andrew Vasquez

> Ok, I see where the confusion lies...  I've always updated
> ql2400_fw.bin to the latest FW version, and simply renamed older
> versions to ql2400_fw.bin.X.YY.ZZ.  To avoid any future uncertainty,
> I've changed the layout a bit and now archive older firmware versions
> in an 'old' directory...

I don't...

- ql2400_fw.bin is dated the 23rd of April 2008.
- The latest ql2400_fw.bin.X.YY.ZZ (now found in old/) is 4.00.27, dated
the 26th of February 2007.

How can I interpret this in any other way but to assume that 4.00.27 was
the latest available from the 26th of February 2007 to the 23rd of April
2008, at which point it was replaced with the current version (4.04.00)?

Anyway.  The problematic box has now been running with FW 4.04.00 and
MSI active for 60 hours now, so it looks like the old FW was the cause
of the instability.  I'll leave it running and will let you know if any
problems occur, though.

Thanks again for your help!

Regards,
-- 
Tore Anderson
