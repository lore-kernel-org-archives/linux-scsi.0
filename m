From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 21/41] scsi: libfc: fc_rport: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 21:51:28 -0500
Message-ID: <yq17egwzjdb.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <1713e55b2fa29809530bc694c37d9cadb22c6f98.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1713e55b2fa29809530bc694c37d9cadb22c6f98.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:30:55 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.21/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
