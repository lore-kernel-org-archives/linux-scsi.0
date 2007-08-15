From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 1/4] libata: check for AN support
Date: Wed, 15 Aug 2007 09:21:13 -0700
Message-ID: <20070815092113.f6546e76.kristen.c.accardi@intel.com>
References: <20070808190613.616085010@localhost.localdomain>
	<20070808120810.5f8ed457.kristen.c.accardi@intel.com>
	<46C2B24E.1010506@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46C2B24E.1010506@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 15 Aug 2007 03:59:10 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Since I wanted to get in Tejun's ata_link changes before this, this will 
> require a rediff.
> 
> But more importantly, as I was going to apply it I noticed another 
> problem:  we need to verify that SiS and NVIDIA both support AN support 
> turning this on, since this patch affects not only Intel but also those 
> vendors' AHCI hardware as well.
> 
> It's a bit annoying but this is a cross-vendor driver after all...
> 
> 	Jeff

Got a link to their public docs?  I'm happy to look in their specs to confirm.
Otherwise, maybe you can forward to people there to have them check, or find
someone under NDA with them who can.

Kristen
