From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 10/41] scsi: bfa: bfa_fcs_lport: Mark expected switch fall-throughs
Date: Fri, 11 Jan 2019 21:48:25 -0500
Message-ID: <yq11s5iy4jq.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <5cc329185c0b92f3aad001fc1afa54996a2c1112.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5cc329185c0b92f3aad001fc1afa54996a2c1112.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:27:15 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied this and two other bfa patches to 5.1/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
