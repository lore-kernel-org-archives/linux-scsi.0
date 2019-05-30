From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Patch v2] target/iscsi: fix possible condition with no effect (if == else)
Date: Wed, 29 May 2019 21:41:52 -0400
Message-ID: <yq1pno0zpjz.fsf@oracle.com>
References: <20190528012151.GA4845@hari-Inspiron-1545>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528012151.GA4845@hari-Inspiron-1545> (Hariprasad Kelam's
        message of "Tue, 28 May 2019 06:51:52 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc: ddiss@suse.de, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hariprasad,

> fix below warning reported by coccicheck
>
> drivers/target/iscsi/iscsi_target_nego.c:175:6-8: WARNING: possible
> condition with no effect (if == else)

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
