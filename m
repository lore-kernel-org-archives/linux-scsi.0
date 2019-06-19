From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/7] NCR5380 drivers: fixes and other improvements
Date: Tue, 18 Jun 2019 22:40:31 -0400
Message-ID: <yq1lfxywb4w.fsf@oracle.com>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1560043151.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Sun, 09 Jun 2019 11:19:11 +1000")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Joshua Thompson <funaho@jurai.org>, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Finn,

> Among other improvements, this patch series fixes a data corruption bug
> in the mac_scsi driver and a bug in the EH abort routine in the core
> 5380 driver.
>
> For consistency I have ignored certain checkpatch.pl complaints about
> the indentation in mac_scsi.c. The remaining complaints seem to be
> false positives.
>
> Some of these patches are not trivial to backport. Those patches have
> been nominated for recent -stable branches only.

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
