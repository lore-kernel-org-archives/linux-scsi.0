From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Resend PATCH] SCSI: scan: fix use-after-free
Date: Tue, 11 Oct 2016 18:01:10 -0400
Message-ID: <yq1wphemtp5.fsf@sermon.lab.mkp.net>
References: <1475990608-4394-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1475990608-4394-1-git-send-email-tom.leiming@gmail.com> (Ming
        Lei's message of "Sun, 9 Oct 2016 13:23:27 +0800")
Sender: stable-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Ming" == Ming Lei <tom.leiming@gmail.com> writes:

Ming> This patch fixes one use-after-free report[1] by KASAN.  In
Ming> __scsi_scan_target(), when a type 31 device is probed,
Ming> SCSI_SCAN_TARGET_PRESENT is returned and the target will be
Ming> scanned again.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
