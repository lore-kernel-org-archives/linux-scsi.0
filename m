From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 9/9] bsg: split handling of SCSI CDBs vs transport requeues
Date: Mon, 23 Oct 2017 02:16:03 -0400
Message-ID: <yq1bmkymlss.fsf@oracle.com>
References: <20171003104845.10417-1-hch@lst.de>
        <20171003104845.10417-10-hch@lst.de>
        <20171019155933.GE26185@bblock-ThinkPad-W530>
        <20171020162630.GA14277@lst.de>
        <20171020164727.GA26380@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24390 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWGQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2017 02:16:12 -0400
In-Reply-To: <20171020164727.GA26380@bblock-ThinkPad-W530> (Benjamin Block's
        message of "Fri, 20 Oct 2017 18:47:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>


Benjamin,

>> Not sure it's worth it especially now that Martin has merged the patch.
>
> He did? I only saw a mail that he picked patches 2-5. So all the bsg
> changes are still open I think.

Yes, I expected the bsg bits to go through Jens' tree.

-- 
Martin K. Petersen	Oracle Linux Engineering
