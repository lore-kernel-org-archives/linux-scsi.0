From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 32/41] scsi: myrb: Mark expected switch fall-throughs
Date: Thu, 20 Dec 2018 19:52:10 -0500
Message-ID: <yq1r2ebbt1h.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:32:52 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Hannes Reinecke <hare@kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.21/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
