From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Wed, 17 Jan 2018 21:43:31 -0500
Message-ID: <yq1shb3ring.fsf@oracle.com>
References: <20180115201852.15152-1-mwilck@suse.com>
        <yq1efmpt3hs.fsf@oracle.com> <1516174344.3303.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:45512 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752275AbeARCor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2018 21:44:47 -0500
In-Reply-To: <1516174344.3303.1.camel@suse.com> (Martin Wilck's message of
        "Wed, 17 Jan 2018 08:32:24 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, saito.kazuya@jp.fujitsu.com


Martin,

> You'd like to spend a precious BLIST bit for this single device which
> uses vendor-specific ASC/Q?

I really don't want string comparisons in the regular code paths. Also
not a fan of vendor-specific ASCs. But if you must use them, please add
a flag and trigger on that.

Since this is a bit of an unusual check condition combo, we could
entertain whether we should simply always ADD_TO_MLQUEUE on
0xb/0xc1/0x1. I wonder what would break?

-- 
Martin K. Petersen	Oracle Linux Engineering
