From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aic94xx: mark expected switch fall-throughs
Date: Tue, 16 Oct 2018 21:55:10 -0400
Message-ID: <yq11s8ppcap.fsf@oracle.com>
References: <20181004071009.GA13875@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181004071009.GA13875@embeddedor.com> (Gustavo A. R. Silva's
        message of "Thu, 4 Oct 2018 09:10:09 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
