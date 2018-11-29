From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 15/41] scsi: hpsa: mark expected switch fall-throughs
Date: Wed, 28 Nov 2018 21:51:18 -0500
Message-ID: <yq1bm68zjdl.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <991ec154d1a1da019442e4fd025a39fa2ad2bebb.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <991ec154d1a1da019442e4fd025a39fa2ad2bebb.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:29:07 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.21/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
