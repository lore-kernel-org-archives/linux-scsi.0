From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: don't reinitialize adapter's req_table
Date: Thu, 25 Aug 2016 22:29:18 -0400
Message-ID: <yq1d1kwb6v5.fsf@sermon.lab.mkp.net>
References: <1471747164-31441-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471747164-31441-1-git-send-email-shawn.lin@rock-chips.com>
        (Shawn Lin's message of "Sun, 21 Aug 2016 10:39:24 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Shawn" == Shawn Lin <shawn.lin@rock-chips.com> writes:

Shawn> req_table is allocate by kzalloc, so we don't need to zero it
Shawn> again anyway.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
