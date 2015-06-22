From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI updates for the 4.0+ merge window
Date: Mon, 22 Jun 2015 16:03:59 -0700
Message-ID: <1435014239.2237.173.camel@HansenPartnership.com>
References: <1435008664.2237.144.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34002 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbbFVXEB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2015 19:04:01 -0400
In-Reply-To: <1435008664.2237.144.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2015-06-22 at 14:31 -0700, James Bottomley wrote:
> This is the usual grab bag of driver updates (lpfc, hpsa, megaraid_sas,
> cxgbi, be2iscsi) plus an assortment of minor updates.  There are also
> two new drivers: the Cisco snic and the IBM cxlflash; the advansys
> driver has been rewritten to get rid of the warning about converting it
> to the DMA API, the tape statistics patch got in and finally, there's a
> resuffle of SCSI header files to separate more cleanly initiator from
> target mode (and better share the common definitions).
> 
> The patch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

Hold off on this, please.  It looks like there's a powerpc regression
with the cxl driver.  Since the cxl commits are the top two on the tree,
I'm just going to drop them and resend the pull request starting from
the existing commit:

commit c8806b6c9e824f47726f2a9b7fbbe7ebf19306fa
Author: Narsimhulu Musini <nmusini@cisco.com>
Date:   Fri May 29 01:04:01 2015 -0700

    snic: driver for Cisco SCSI HBA

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
