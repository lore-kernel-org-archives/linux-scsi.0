From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: GFP_DMA Janitation
Date: Mon, 16 Dec 2002 15:33:51 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212161530580.10808-100000@humbolt.us.dell.com>
References: <20021214053518.K10991@parcelfarce.linux.theplanet.co.uk>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021214053518.K10991@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org, Janitors <kernel-janitor-discuss@lists.sourceforge.net>

> I know there's a lot of clean-up and janitorial work going on at the
> moment, so maybe someone already fixed the bogus uses of GFP_DMA in
> drivers/scsi?
> drivers/scsi/megaraid.c:5020:   _tv = (void *)__get_free_pages(GFP_DMA, order);

The megaraid 2.00.2 driver (2.00.1 is in -ac right now) gets this right 
(in fact, there are no GFP_DMA allocations ever, it uses the PCI DMA API 
properly).

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


