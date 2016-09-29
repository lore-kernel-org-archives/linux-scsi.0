From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH 0/2] libfc/fcoe Fixes
Date: Thu, 29 Sep 2016 08:45:31 -0400
Message-ID: <alpine.OSX.2.00.1609290844450.361@administrators-macbook-pro.local>
References: <1475083849-13478-1-git-send-email-chad.dupuis@cavium.com> <0d7d74ff-7b38-5515-6652-6ea174dfb14a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:41834
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754412AbcI2PS1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 11:18:27 -0400
In-Reply-To: <0d7d74ff-7b38-5515-6652-6ea174dfb14a@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org



On Thu, 29 Sep 2016, 8:06am -0000, Hannes Reinecke wrote:

> Hi Chad,
> 
> On 09/28/2016 07:30 PM, Chad Dupuis wrote:
> > 
> > During testing we fixed a deadlock we found in libfc while logging off from the
> > fabric if an ELS command was still outstanding.  Also we wanted to make clear
> > virtual link handling a little more robust when the fcoe_ctlr is not logged
> > into the fabric.
> > 
> > Please apply at your earliest convenience.
> > 
> > Thanks,
> > Chad
> > 
> > Chad Dupuis (2):
> >   fcoe: Harden CVL handling when we have not logged into the fabric.
> >   libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS
> >     response.
> > 
> >  drivers/scsi/fcoe/fcoe_ctlr.c | 35 ++++++++++++++++++++++++++++++++---
> >  drivers/scsi/libfc/fc_rport.c | 32 ++++++++++++++++++++++++--------
> >  2 files changed, 56 insertions(+), 11 deletions(-)
> > 
> I'm currently preparing a larger FCoE patchset (for my VN2VN fixes),
> which also includes the second patch.
> Should I take the first one, too, and submit it in one bunch or do you
> prefer to keep both separate?
> 
> Cheers,
> 
> Hannes
> 

I'm fine either way to be honest...whatever is easier for Martin.
