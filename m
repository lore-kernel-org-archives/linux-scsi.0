From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/2] hpsa: limit transfer length to 1MB
Date: Mon, 17 Jul 2017 22:57:12 -0400
Message-ID: <yq1k236fo53.fsf@oracle.com>
References: <20170623094006.16807-1-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623094006.16807-1-ydfan@suse.com> (Yadan Fan's message of
        "Fri, 23 Jun 2017 17:40:05 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yadan Fan <ydfan@suse.com>
Cc: don.brace@microsemi.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yadan,

> The hpsa firmware will bypass the cache for any request larger
> than 1MB, so we should cap the request size to avoid any
> performance degradation in kernels later than v4.3

Applied to 4.13/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
