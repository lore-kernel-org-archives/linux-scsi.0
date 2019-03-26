From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla4xxx: avoid freeing unallocated dma memory
Date: Mon, 25 Mar 2019 22:16:28 -0400
Message-ID: <yq1y352z8g3.fsf@oracle.com>
References: <20190322142530.904080-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190322142530.904080-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 22 Mar 2019 15:25:03 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Manish Rangankar <mrangankar@marvell.com>, Chengguang Xu <cgxu519@gmx.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Clang -Wuninitialized notices that on is_qla40XX we never allocate any
> DMA memory in get_fw_boot_info() but attempt to free it anyway:

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
