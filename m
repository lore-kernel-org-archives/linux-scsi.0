From: Andi Kleen <ak@suse.de>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 2 Oct 2006 20:17:59 +0200
Message-ID: <200610022017.59697.ak@suse.de>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org> <20061002105733.a9e82ddf.akpm@osdl.org> <b1bc6a000610021106gab7efe7jcbab275b5030db9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:62884 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S965233AbWJBSSL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 14:18:11 -0400
In-Reply-To: <b1bc6a000610021106gab7efe7jcbab275b5030db9e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org


> > > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> > > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> > > 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> > > nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff

nommu_* means he didn't compile in the IOMMU code.

Operator error -> invalid.

-Andi
