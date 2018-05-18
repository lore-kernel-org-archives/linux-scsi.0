From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qlogicpti: Fix an error handling path in 'qpti_sbus_probe()'
Date: Fri, 18 May 2018 12:25:46 -0400
Message-ID: <yq1h8n5exrp.fsf@oracle.com>
References: <20180510114558.20769-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180510114558.20769-1-christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Thu, 10 May 2018 13:45:58 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christophe,

> The 'free_irq()' call is not at the right place in the error handling
> path.  The changed order has been introduced in commit 3d4253d9afab
> ("[SCSI] qlogicpti: Convert to new SBUS device framework.")

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
