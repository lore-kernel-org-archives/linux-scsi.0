From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] g_NCR5380: Bug fix and some enhancements
Date: Thu, 08 Dec 2016 16:59:02 -0500
Message-ID: <yq1shpyozfd.fsf@sermon.lab.mkp.net>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Mon, 5 Dec 2016 01:07:19 -0500 (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> This patch series is based on the one submitted recently by Ondrej
Finn> Zary.  This version has a different irq probing fix for HP C2502
Finn> boards and a more comprehensive patch to change the default irq
Finn> parameter.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
