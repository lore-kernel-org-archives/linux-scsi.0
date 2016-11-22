From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when unloading
Date: Mon, 21 Nov 2016 22:47:20 -0500
Message-ID: <yq1lgwcyy47.fsf@sermon.lab.mkp.net>
References: <20161121140429.12788-1-mwilck@suse.de>
        <20161121140429.12788-2-mwilck@suse.de>
        <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16836 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbcKVDry (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2016 22:47:54 -0500
In-Reply-To: <20161121141336.gkc35pjmlojhxm35@linux-x5ow.site> (Johannes
        Thumshirn's message of "Mon, 21 Nov 2016 15:13:36 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Martin Wilck <mwilck@suse.de>, don.brace@pmcs.com, storagedev@pmcs.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, JBottomley@odin.com, hch@lst.de, hare@suse.de

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> I don't think the SUSE bugzilla tag is of relevance upstream.

Nope. I'd rather have really comprehensive patch descriptions.

Johannes> But for sake of completeness we could add a Link:
Johannes> https://bugzilla.suse.com/show_bug.cgi?id=1010946

"You are not authorized to access bug #1010946. To see this bug, you
must first log in to an account with the appropriate permissions."

We'll see what the Microsemi folks think of the patches. If the patches
get acked I can just drop the bsc tag when I apply.

-- 
Martin K. Petersen	Oracle Linux Engineering
