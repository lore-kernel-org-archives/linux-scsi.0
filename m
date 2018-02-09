From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/6] scsi: qedf: fix LTO-enabled build
Date: Fri, 09 Feb 2018 18:24:42 -0500
Message-ID: <yq1mv0hvj9h.fsf@oracle.com>
References: <20180202131225.1658853-1-arnd@arndb.de>
        <20180202131225.1658853-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180202131225.1658853-5-arnd@arndb.de> (Arnd Bergmann's message
        of "Fri, 2 Feb 2018 14:12:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, QLogic-Storage-Upstream@cavium.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicolas Pitre <nico@linaro.org>, Andi Kleen <ak@linux.intel.com>, Chad Dupuis <chad.dupuis@cavium.com>, Nilesh Javali <nilesh.javali@cavium.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> The prototype for qedf_dbg_fops/qedf_debugfs_ops doesn't match the
> definition, which causes the final link to fail with link-time
> optimizations:

Applied to 4.17/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
