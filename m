From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] megaraid_sas: Fix LD/VF affiliation parsing
Date: Thu, 3 Jul 2014 01:18:01 -0700
Message-ID: <20140703081801.GA22818@infradead.org>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
 <1404173998-24363-4-git-send-email-aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaGCISB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 04:18:01 -0400
Content-Disposition: inline
In-Reply-To: <1404173998-24363-4-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Radford <aradford@gmail.com>
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

On Mon, Jun 30, 2014 at 05:19:57PM -0700, Adam Radford wrote:
> James/linux-scsi,
> 
> The following patch for megaraid_sas fixes the LD/VF affiliation policy parsing code to account for LD targetId's and Hidden LD's (not yet affiliated with any Virtual Functions).

Hi Adam,

this doesn't address Martins comment about removing the initial != 0
case.  And while we're at it there basically is no significant shared
code between the PlasmaFW111 and !PlasmaFW111, so split these into
two different functions.  With those two levels of indentation removed
the code might actually become readable, too.

Also please remove the "James/linux-scsi," address in the individual
patches, that's something that should just go into the cover letter,
and make sure to include all "Reviewed-by:" and "Acked-by:" tags when
resending already reviewd patches.

Thanks,
	Christoph
