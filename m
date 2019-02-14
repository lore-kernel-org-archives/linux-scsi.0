From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qlogicpti: Use of_node_name_eq for node name comparisons
Date: Wed, 13 Feb 2019 22:14:21 -0500
Message-ID: <yq11s4bqcxe.fsf@oracle.com>
References: <20190213160829.3923-1-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213160829.3923-1-robh@kernel.org> (Rob Herring's message of
        "Wed, 13 Feb 2019 10:08:29 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-scsi@vger.kernel.org, Meelis Roos <mroos@linux.ee>
List-Id: linux-scsi@vger.kernel.org


Rob,

> -	qpti->is_pti = strcmp(qpti->prom_name, "QLGC,isp");
> +	qpti->is_pti = !of_node_name_eq(op->dev.of_node, "QLGC,isp");

The apparent polarity inversion made me blink but it appears to be
correct (is_pti is set if it's not an isp controller). Makes me wonder
if the driver is doing the right thing for a "SUNW,isp", though...

Meelis: Do you have anything that identifies itself as SUNW,isp?

In any case: Applied to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
