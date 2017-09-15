From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bnx2i: Clean up unused pointers in bnx2i_hwi
Date: Fri, 15 Sep 2017 15:41:08 -0400
Message-ID: <yq14ls3px63.fsf@oracle.com>
References: <1505045934-16272-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505045934-16272-1-git-send-email-chris.gekas@gmail.com>
        (Christos Gkekas's message of "Sun, 10 Sep 2017 13:18:54 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christos Gkekas <chris.gekas@gmail.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christos,

> Pointers bnx2i_cmd are set but never used, so they can be removed.

Applied to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
