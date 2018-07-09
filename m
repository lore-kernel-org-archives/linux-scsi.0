From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/2] Remove remainig MCR SCSI drivers
Date: Mon, 9 Jul 2018 09:16:04 +0200
Message-ID: <20180709071604.vrc3xjw76qr64k7n@linux-x5ow.site>
References: <20180706133349.28508-1-jthumshirn@suse.de>
 <1530899576.3142.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1530899576.3142.3.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 06, 2018 at 10:52:56AM -0700, James Bottomley wrote:
> On Fri, 2018-07-06 at 15:33 +0200, Johannes Thumshirn wrote:
> > MCR Support was ripped out of the kernel in 2012. I think 6 years
> > later we can kill the remaining drivers which couldn't have been
> > compiled since then.
> > 
> > Johannes Thumshirn (2):
> >   scsi: remove NCR_D700 driver
> >   scsi: remove NCR_Q720 driver
> 
> Since they're my drivers,
> 
> Acked-by: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>

Thanks a lot.
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
