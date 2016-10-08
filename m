From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: replace wrong device handler name for CLARiiON
 arrays
Date: Sun, 09 Oct 2016 07:21:45 +0800
Message-ID: <1475968905.2892.11.camel@linux.vnet.ibm.com>
References: <20161007161957.6042-1-xose.vazquez@gmail.com>
         <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751888AbcJHXV4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2016 19:21:56 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u98NIoCa103291
        for <linux-scsi@vger.kernel.org>; Sat, 8 Oct 2016 19:21:55 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 25xwabgjc1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2016 19:21:55 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Sat, 8 Oct 2016 17:21:54 -0600
In-Reply-To: <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Sat, 2016-10-08 at 19:17 +0200, Hannes Reinecke wrote:
> On 10/07/2016 06:19 PM, Xose Vazquez Perez wrote:
> > At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
> > #define CLARIION_NAME                   "emc"
> > 
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: SCSI ML <linux-scsi@vger.kernel.org>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  drivers/scsi/scsi_dh.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> > index 54d446c..b8d3b97 100644
> > --- a/drivers/scsi/scsi_dh.c
> > +++ b/drivers/scsi/scsi_dh.c
> > @@ -36,9 +36,9 @@ struct scsi_dh_blist {
> >  };
> > 
> >  static const struct scsi_dh_blist scsi_dh_blist[] = {
> > -	{"DGC", "RAID",			"clariion" },
> > -	{"DGC", "DISK",			"clariion" },
> > -	{"DGC", "VRAID",		"clariion" },
> > +	{"DGC", "RAID",			"emc" },
> > +	{"DGC", "DISK",			"emc" },
> > +	{"DGC", "VRAID",		"emc" },
> > 
> >  	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
> >  	{"COMPAQ", "HSV110",		"hp_sw" },
> > 
> Whee. Of course.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Actually, should we replace?  Aren't there older arrays still bearing
the clariion name, so we should have these entries in addition?

James


