From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] libfc/fcoe Fixes
Date: Thu, 29 Sep 2016 10:06:53 +0200
Message-ID: <0d7d74ff-7b38-5515-6652-6ea174dfb14a@suse.de>
References: <1475083849-13478-1-git-send-email-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35895 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbcI2IGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 04:06:55 -0400
In-Reply-To: <1475083849-13478-1-git-send-email-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

Hi Chad,

On 09/28/2016 07:30 PM, Chad Dupuis wrote:
> 
> During testing we fixed a deadlock we found in libfc while logging off from the
> fabric if an ELS command was still outstanding.  Also we wanted to make clear
> virtual link handling a little more robust when the fcoe_ctlr is not logged
> into the fabric.
> 
> Please apply at your earliest convenience.
> 
> Thanks,
> Chad
> 
> Chad Dupuis (2):
>   fcoe: Harden CVL handling when we have not logged into the fabric.
>   libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS
>     response.
> 
>  drivers/scsi/fcoe/fcoe_ctlr.c | 35 ++++++++++++++++++++++++++++++++---
>  drivers/scsi/libfc/fc_rport.c | 32 ++++++++++++++++++++++++--------
>  2 files changed, 56 insertions(+), 11 deletions(-)
> 
I'm currently preparing a larger FCoE patchset (for my VN2VN fixes),
which also includes the second patch.
Should I take the first one, too, and submit it in one bunch or do you
prefer to keep both separate?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
