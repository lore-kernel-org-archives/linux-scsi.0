From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: not need to alloc zero buffer for local_atto_ioctl
Date: Thu, 25 Aug 2016 22:29:01 -0400
Message-ID: <yq1h9a8b6vm.fsf@sermon.lab.mkp.net>
References: <1471746809-31218-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471746809-31218-1-git-send-email-shawn.lin@rock-chips.com>
        (Shawn Lin's message of "Sun, 21 Aug 2016 10:33:29 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Shawn" == Shawn Lin <shawn.lin@rock-chips.com> writes:

Shawn> We don't need to use kzalloc as we will always memset the
Shawn> local_atto_ioctl later.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
