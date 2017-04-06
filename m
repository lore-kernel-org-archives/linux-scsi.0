From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Make checking the scsi_device_get() return value
 mandatory
Date: Thu, 6 Apr 2017 10:25:08 +0200
Message-ID: <20170406082508.GA3768@linux-x5ow.site>
References: <201704060817.vbFGWYzD%fengguang.wu@intel.com>
 <1491438642.2787.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33459 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752692AbdDFIZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 04:25:14 -0400
Content-Disposition: inline
In-Reply-To: <1491438642.2787.17.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Thu, Apr 06, 2017 at 12:30:43AM +0000, Bart Van Assche wrote:
> On Thu, 2017-04-06 at 08:27 +0800, kbuild test robot wrote:
> > All warnings (new ones prefixed by >>):
> > 
> >    drivers//scsi/osd/osd_uld.c: In function 'osd_probe':
> > > > drivers//scsi/osd/osd_uld.c:467:2: warning: ignoring return value of 'scsi_device_get', declared with attribute warn_unused_result [-Wunused-result]
> > 
> >      scsi_device_get(scsi_device);
> >      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Please ignore this warning. It is triggered because patch "osd_uld: Check
> scsi_device_get() return value" is not yet upstream.

And verified this patch is valuable ;-)

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
