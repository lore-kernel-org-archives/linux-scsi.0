From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mptfusion: mark expected switch fall-throughs
Date: Tue, 10 Jul 2018 22:52:02 -0400
Message-ID: <yq1h8l6pjql.fsf@oracle.com>
References: <20180703222003.GA4593@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703222003.GA4593@embeddedor.com> (Gustavo A. R. Silva's
        message of "Tue, 3 Jul 2018 17:20:03 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Gustavo A.,

> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.

Applied to 4.19/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
