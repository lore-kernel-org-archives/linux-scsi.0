From: Tore Anderson <tore@linpro.no>
Subject: Re: Recurring qla2xxx crashes (maybe APIC related)
Date: Wed, 30 Apr 2008 10:32:15 +0200
Message-ID: <48182E8F.6000009@linpro.no>
References: <4811ACAC.7060808@linpro.no> <20080425155018.GG8849@plap4> <48120F8B.7060005@linpro.no> <20080425171821.GK8849@plap4> <4815709C.3060502@linpro.no> <20080429211655.GA72811@plap4.qlogic.org> <4817970A.4030807@linpro.no> <20080429222947.GE72811@plap4.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.linpro.no ([213.236.139.167]:33819 "EHLO
	mailhub.linpro.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYD3IcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 04:32:17 -0400
In-Reply-To: <20080429222947.GE72811@plap4.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi,

* Andrew Vasquez

> We did notice that the RISC firmware being loaded is quite dated (15 
> months):

I did ensure that we were running the latest firmware when trying to
track down the problem.  From what I can tell 4.00.27 was the latest
available on your FTP up until the 23rd of April.  I simply didn't check
to see if any updates were published in the last week.

> At a minimum, our FW folks suggested 4.01.00 should be used to
> address any known residual MSI issues at the RISC-side.  You can
> download the latest 24xx firmware (4.04.00) here:

The sysadmins have requested that I leave the box alone for a few days
more so we can tell our customer that we're 100% confident we have a
viable workaround for the stability problems.  I'll reboot with MSI
enabled and FW 4.04.00 on Friday, and will let you know how it's going
on Monday.

I hope you're okay with waiting until then.

Regards,
-- 
Tore Anderson
