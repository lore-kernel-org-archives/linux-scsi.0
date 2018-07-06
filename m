From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Fri, 6 Jul 2018 10:03:01 +0200
Message-ID: <20180706080301.gvjxdd4w5eun2x2h@linux-x5ow.site>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-2-jthumshirn@suse.de>
 <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2018 at 05:42:02PM +0000, Dave Carroll wrote:
> > Remove the AAC_STAT_GOOD definition and open code it in the places it was
> > used.
> > 
> > This will make subsequent refactoring in this area easier.
> > 
> Please don't ... the definition itself was added to make refactoring easier.

Well in the end scsi_cmnd::result as we know it currently will go
away, so splitting up the define is rather crucial for this. I could
do it when changing the ->result from one integer into 4 u8s but doing
it in a separate preparation step would be preferable to me and it
doesn't hurt accraid at all.

For more information please see [1] and [2]. A first preparation
series [3] has already landed upstream.

[1] https://marc.info/?l=linux-scsi&m=152300071418035&w=2
[2] https://marc.info/?l=linux-scsi&m=152406381222604&w=2
[3] https://marc.info/?l=linux-scsi&m=152887646121085&w=2

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
