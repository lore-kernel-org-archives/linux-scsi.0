From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ppa: mark expected switch fall-throughs
Date: Mon, 20 Nov 2017 21:34:01 -0500
Message-ID: <yq1efosnyw6.fsf@oracle.com>
References: <20171108171739.GA9139@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171108171739.GA9139@embeddedor.com> (Gustavo A. R. Silva's
        message of "Wed, 8 Nov 2017 11:17:39 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.16/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
