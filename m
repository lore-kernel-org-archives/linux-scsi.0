From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/41] scsi: aacraid: aachba: Mark expected switch fall-throughs
Date: Wed, 28 Nov 2018 21:50:52 -0500
Message-ID: <yq1k1kwzjeb.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <fba277107d0b94bdd6e7cabf1d17e0fb0b6e13d8.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fba277107d0b94bdd6e7cabf1d17e0fb0b6e13d8.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:25:41 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.21/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
