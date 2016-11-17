From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: introduce a new ufshcd_statea UFSHCD_STATE_EH_SCHEDULED
Date: Wed, 16 Nov 2016 20:29:59 -0500
Message-ID: <yq1bmxec2qw.fsf@sermon.lab.mkp.net>
References: <20161116032937.117395-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51015 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932688AbcKQBaK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 20:30:10 -0500
In-Reply-To: <20161116032937.117395-1-zangleigang@hisilicon.com> (Zang
        Leigang's message of "Wed, 16 Nov 2016 11:29:37 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

>>>>> "Zang" == Zang Leigang <zangleigang@hisilicon.com> writes:

Zang> Add a new ufshcd_state, indicats that an err handler may get to
Zang> run immediately. Use UFSHCD_STATE_ERROR here looks not literaly
Zang> correct.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
