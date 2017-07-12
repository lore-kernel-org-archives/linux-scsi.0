From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] smartpqi: limit transfer length to 1MB
Date: Wed, 12 Jul 2017 17:27:08 -0400
Message-ID: <yq1shi1jqhf.fsf@oracle.com>
References: <20170623094006.16807-1-ydfan@suse.com>
        <20170623094006.16807-2-ydfan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623094006.16807-2-ydfan@suse.com> (Yadan Fan's message of
        "Fri, 23 Jun 2017 17:40:06 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com
Cc: Yadan Fan <ydfan@suse.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Don,

> The smartpqi firmware will bypass the cache for any request larger
> than 1MB, so we should cap the request size to avoid any
> performance degradation in kernels later than v4.3

Ping on these...

-- 
Martin K. Petersen	Oracle Linux Engineering
