From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] libfc/fcoe Fixes
Date: Thu, 29 Sep 2016 21:40:38 -0400
Message-ID: <yq14m4yw4fd.fsf@sermon.lab.mkp.net>
References: <1475083849-13478-1-git-send-email-chad.dupuis@cavium.com>
        <0d7d74ff-7b38-5515-6652-6ea174dfb14a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16962 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934990AbcI3Bky (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2016 21:40:54 -0400
In-Reply-To: <0d7d74ff-7b38-5515-6652-6ea174dfb14a@suse.de> (Hannes Reinecke's
        message of "Thu, 29 Sep 2016 10:06:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Chad Dupuis <chad.dupuis@cavium.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> I'm currently preparing a larger FCoE patchset (for my VN2VN
Hannes> fixes), which also includes the second patch.  Should I take the
Hannes> first one, too, and submit it in one bunch or do you prefer to
Hannes> keep both separate?

Well, 4.9 is right around the corner so I'm guessing your patchset will
be aimed at 4.10. But assuming we get some quick reviews for Chad's
patches we could squeeze those in.

-- 
Martin K. Petersen	Oracle Linux Engineering
