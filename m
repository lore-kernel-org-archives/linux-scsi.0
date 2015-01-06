From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: RFC: should we deprecate unmaintained isa-only drivers?
Date: Tue, 6 Jan 2015 23:27:28 +0100
Message-ID: <201501062327.28830.linux@rainbow-software.org>
References: <20141230160616.GA29149@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:47045 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbbAFW2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2015 17:28:03 -0500
In-Reply-To: <20141230160616.GA29149@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Miroslav Zagorac <zaga@fly.cc.fer.hr>, Dario Ballabio <ballabio_dario@emc.com>

On Tuesday 30 December 2014 17:06:16 Christoph Hellwig wrote:
> We've got a few very old, isa-only SCSI HBA drivers in the tree.  Of
> those only one (aha152x) sas significant maintaince since the dawn
> of git, all others only saw global / automatic updates.  4 of those
> are fairly trivial wrappers aroudn the NCR538 core, so I don't mind
> keeping them:
>
>  - dtc
>  - g_NCR5380
>  - pas16
>  - t128
>
> but I'd love to know if anyone is actually using the other drivers:
>
>  - wd7000
>  - aha1542
>  - in2000
>  - NCR53c406
>  - sym53c416
>  - u14-34f
>  - ultrastor
>
> note that the last two even drive the same hardware.  There is
> significant cruft in all these, so dropping them would help
> further maintainance of the SCSI midlayer.

I think I have a AHA-1542B ISA card so I can fix the aha1542 driver.

-- 
Ondrej Zary
