From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/12] Fixes, cleanup and g_NCR5380_mmio/g_NCR5380 merger
Date: Fri, 14 Oct 2016 16:11:31 -0400
Message-ID: <yq1a8e6lmh8.fsf@sermon.lab.mkp.net>
References: <cover.1475555997.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1475555997.git.fthain@telegraphics.com.au> (Finn Thain's
        message of "Tue, 4 Oct 2016 00:47:58 -0400 (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> This patch series has fixes for compatibility, reliability and
Finn> performance issues and some cleanup. It also includes a new
Finn> version of Ondrej Zary's patch that merges g_NCR5380_mmio into
Finn> g_NCR5380.

Finn> I've tested this patch series on a Powerbook 180. If someone would
Finn> test some of the other platforms that would be very helpful. All
Finn> drivers were compile-tested.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
