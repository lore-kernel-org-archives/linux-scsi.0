From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/2] Add SATA support to libsas/aic94xx
Date: Sun, 20 Aug 2006 22:33:53 -0500
Message-ID: <1156131233.3567.21.camel@mulgrave.il.steeleye.com>
References: <44DBE93F.1040005@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:10376 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932306AbWHUDd4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 23:33:56 -0400
In-Reply-To: <44DBE93F.1040005@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

On Thu, 2006-08-10 at 19:19 -0700, Darrick J. Wong wrote:
> These patches are based off 2.6.18-rc4 + jejb's scsi-misc, scsi-rc and
> aic94xx git trees + Brian King's libata SAS patches.
> 
> Questions/comments?  Thanks in advance for feedback,

Well, thanks to the generosity of Google, I too now have a SATA device.
What I find is that your patches work perfectly for a directly attached
SATA device.  However, they don't seem to work at all for a SATA device
attached to an expander.  It looks like the SATA expander discovery
process isn't working correctly (it also looks like the expander I have
has to be specially programmed ... the SATA device shows a flashing
orange light until the fusion sas card discovers it; with aic94xx it
always shows a flashing orange light, even after discovery).

I'll try to find time next week to dig into the discovery process.

James


