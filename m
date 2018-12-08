From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Use of_node_name_eq for node name comparisons
Date: Fri, 07 Dec 2018 21:57:47 -0500
Message-ID: <yq1zhtglo7o.fsf@oracle.com>
References: <20181205195050.4759-23-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205195050.4759-23-robh@kernel.org> (Rob Herring's message
        of "Wed, 5 Dec 2018 13:50:39 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Rob,

> Convert string compares of DT node names to use of_node_name_eq helper
> instead. This removes direct access to the node name pointer.

Applied to 4.21/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
