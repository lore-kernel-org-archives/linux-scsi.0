From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] device_handler: remove VLAs
Date: Mon, 12 Mar 2018 22:37:47 -0400
Message-ID: <yq1tvtkem4k.fsf@oracle.com>
References: <20180309232933.14e39858@heffalump.sk2.org>
        <20180309223211.20473-1-steve@sk2.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309223211.20473-1-steve@sk2.org> (Stephen Kitt's message of
        "Fri, 9 Mar 2018 23:32:11 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Kitt <steve@sk2.org>
Cc: hare@suse.com, axboe@kernel.dk, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Stephen,

> In preparation to enabling -Wvla, remove VLAs and replace them with
> fixed-length arrays instead.
>
> scsi_dh_{alua,emc,rdac} use variable-length array declarations to
> store command blocks, with the appropriate size as determined by
> COMMAND_SIZE. This patch replaces these with fixed-sized arrays using
> MAX_COMMAND_SIZE, so that the array size can be determined at compile
> time.

Applied to 4.17/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
