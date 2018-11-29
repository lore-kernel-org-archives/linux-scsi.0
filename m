From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 04/41] scsi: aacraid: linit: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 21:51:03 -0500
Message-ID: <yq1ftvkzje0.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <d59c13880a70724c3645d96945bf8a128f835244.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d59c13880a70724c3645d96945bf8a128f835244.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:26:09 -0600")
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
