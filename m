From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Wed, 17 Jan 2018 08:32:24 +0100
Message-ID: <1516174344.3303.1.camel@suse.com>
References: <20180115201852.15152-1-mwilck@suse.com>
         <yq1efmpt3hs.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:38337 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbeAQHck (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 17 Jan 2018 02:32:40 -0500
In-Reply-To: <yq1efmpt3hs.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, saito.kazuya@jp.fujitsu.com

On Wed, 2018-01-17 at 01:15 -0500, Martin K. Petersen wrote:
> Martin,
> 
> > +		if (!strncmp(scmd->device->vendor, "FUJITSU", 7)
> > &&
> > +			   !strncmp(scmd->device->model,
> > "ETERNUS_DXM", 11) &&
> 
> Blacklist, please.
> 

To make sure I understand correctly:

You'd like to spend a precious BLIST bit for this single device which
uses vendor-specific ASC/Q?

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
