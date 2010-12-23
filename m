From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC] lldd_I_T_nexus_reset use in sas_ata.c
Date: Thu, 23 Dec 2010 15:05:06 -0600
Message-ID: <1293138306.10141.14.camel@mulgrave.site>
References: <AANLkTimTDLOv8A7Vq3y6-8L4VA8PpU135fSQZH8SgaKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41014 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab0LWVFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2010 16:05:13 -0500
In-Reply-To: <AANLkTimTDLOv8A7Vq3y6-8L4VA8PpU135fSQZH8SgaKQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Tuffli <ctuffli@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-12-23 at 11:34 -0800, Chuck Tuffli wrote:
> Can some shed light on why sas_ata_phy_reset() does an I_T nexus
> reset? It seems like calling sas_phy_reset() might be more accurate in
> this case. Thanks.

It needs an ATA reset that propagates.  ATA resets don't key off SAS phy
resets, they have a separate reset sequence, which is triggered by the
I_T nexus reset.

James


