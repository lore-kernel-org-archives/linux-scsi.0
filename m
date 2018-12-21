From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v2] megaraid: fix out-of-bound array accesses
Date: Thu, 20 Dec 2018 19:50:34 -0500
Message-ID: <yq1va3nbt45.fsf@oracle.com>
References: <20181206212252.36732-1-cai@lca.pw>
        <20181213132727.57058-1-cai@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181213132727.57058-1-cai@lca.pw> (Qian Cai's message of "Thu,
        13 Dec 2018 08:27:27 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: akpm@linux-foundation.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, thenzl@redhat.com, hch@lst.de, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Qian,

> UBSAN reported those with MegaRAID SAS-3 3108,

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
