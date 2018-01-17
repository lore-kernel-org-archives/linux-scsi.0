From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Wed, 17 Jan 2018 01:15:43 -0500
Message-ID: <yq1efmpt3hs.fsf@oracle.com>
References: <20180115201852.15152-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750810AbeAQGP6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 01:15:58 -0500
In-Reply-To: <20180115201852.15152-1-mwilck@suse.com> (Martin Wilck's message
        of "Mon, 15 Jan 2018 21:18:52 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, saito.kazuya@jp.fujitsu.com


Martin,

> +		if (!strncmp(scmd->device->vendor, "FUJITSU", 7) &&
> +			   !strncmp(scmd->device->model, "ETERNUS_DXM", 11) &&

Blacklist, please.

-- 
Martin K. Petersen	Oracle Linux Engineering
