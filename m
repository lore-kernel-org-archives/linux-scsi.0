From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] 2.4.27rc2, DVD-RW support broke DVD-RAM writes
Date: 16 Aug 2004 11:07:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092676046.4235.11.camel@patlinux.iomegacorp.com>
References: <20040730153657.GB2748@logos.cnet><20040731163334.GH23697@suse.
	de><76A380F2-E3C5-11D8-B01E-00039398BB5E@ieee.org><06E9D950-E3EF-11D8-B976-
	00039398BB5E@ieee.org><70B2077E-E401-11D8-B976-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:33756 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S267798AbUHPRIg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 13:08:36 -0400
In-Reply-To: <70B2077E-E401-11D8-B976-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org

> drivers/scsi/sr.c ... vendor-specific op x1A 
> reaching the drive, by analogy with SPC op x1A "MODE SENSE (6)", in 
> place of the standard MMC op x5A "MODE SENSE (10)" ...

I've now concretely proposed fixing this in drivers/scsi/.

Subject: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
http://marc.theaimsgroup.com/?l=linux-scsi&m=109267404822826

Of course I'll return to drivers/usb/storage/ if the drivers/scsi/ folk
say I should.

Pat LaVarre


