From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Thu, 21 Dec 2017 09:48:09 +0100
Message-ID: <20171221084809.jopfma3hsjez4s33@linux-x5ow.site>
References: <20171221024049.36509-1-yanaijie@huawei.com>
 <c8a634e9-22b8-ac99-e0db-05b1566ed2e9@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47574 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdLUIsM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 03:48:12 -0500
Content-Disposition: inline
In-Reply-To: <c8a634e9-22b8-ac99-e0db-05b1566ed2e9@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Jason Yan <yanaijie@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Dec 21, 2017 at 05:41:00AM +0000, Damien Le Moal wrote:
> Jason,
> 
> On 12/21/17 11:40, Jason Yan wrote:
> > My editor always try to remove the extra white space at the end of the
> > line when I make some changes. I'm tired of adjusting them manually.
> > Can we remove them in mainline?
> > 
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> > ---
> >  drivers/scsi/scsi.c       |  2 +-
> >  drivers/scsi/scsi_lib.c   | 20 ++++++++++----------
> >  drivers/scsi/scsi_scan.c  | 10 +++++-----
> >  drivers/scsi/scsi_sysfs.c |  4 ++--
> >  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> There are plenty in drivers/scsi/sd.c too :)
> I would also love to get rid of these white spaces so that my emacs
> stops looking like a Christmas tree all year long.
> Last time I tried I got nacked...
> 
> Martin,
> 
> What about a (may be big) whitespace-only patch to clean up all the scsi
> code and finally get checkpatch to stop screaming at us if we touch a
> line near one with whitespaces (which can happen a lot...) ?

+1 

Please let's get rid of this whitespace mess.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
