From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/41] scsi: esas2r: esas2r_init: mark expected switch fall-throughs
Date: Fri, 11 Jan 2019 21:45:32 -0500
Message-ID: <yq15zuuy4oj.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <eb98d6f510cd93e45d7832837acd4e5811f3d20e.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eb98d6f510cd93e45d7832837acd4e5811f3d20e.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:28:57 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
