From: Joerg Roedel <joro@8bytes.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Mon, 23 Mar 2015 16:03:04 +0100
Message-ID: <20150323150304.GQ4441@8bytes.org>
References: <54E1FFFA.1060403@compro.net>
 <54F60D33.8090401@compro.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:35473 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbbCWPDG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Mar 2015 11:03:06 -0400
Content-Disposition: inline
In-Reply-To: <54F60D33.8090401@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Hounschell <markh@compro.net>
Cc: "linux-scsi@vger.kernel.org >> SCSI development list" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org

Hi Mark,

On Tue, Mar 03, 2015 at 02:36:19PM -0500, Mark Hounschell wrote:
> It looks like this problem is NOT a bug with the SCSI aic7xxx driver
> after all. I can duplicate this BUG very easily with other hardware.
> Simply removing a driver module  (whether it its self, has actually
> used any of the DMA API or not) that is sitting on the same pci bus
> as a card that is actually using DMA will cause this. And that card
> that is in use and using DMA will no longer function. It "looks and
> feels" like unloading a module causes the IOMMU to improperly unmap
> valid mappings.

You are right, I looked into the code and found the problem. I'll post a
fix for testing this week.


	Joerg

