From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 30/41] scsi: megaraid_sas_fusion: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 21:51:58 -0500
Message-ID: <yq1y39cy4s1.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
        <5fceeac101cc3dfe4a129764a139c1b616cba292.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5fceeac101cc3dfe4a129764a139c1b616cba292.1543374820.git.gustavo@embeddedor.com>
        (Gustavo A. R. Silva's message of "Tue, 27 Nov 2018 22:32:34 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, megaraidlinux.pdl@broadcom.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Notice that, in this particular case, I replaced "Fall thru" with a
> "Fall through" annotation and added a dash as a token in order to
> separate the "Fall through" annotation from the rest of the comment
> on the same line, which is what GCC is expecting to find.

Applied to 4.21/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
