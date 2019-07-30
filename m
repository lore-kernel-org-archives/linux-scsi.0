From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Mark expected switch fall-throughs
Date: Tue, 30 Jul 2019 16:00:35 -0400
Message-ID: <yq1wofzl2cc.fsf@oracle.com>
References: <20190729112902.GA3768@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729112902.GA3768@embeddedor> (Gustavo A. R. Silva's message
        of "Mon, 29 Jul 2019 06:29:02 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org


Gustavo,

> Mark switch cases where we are expecting to fall through.

Applied to 5.4/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
