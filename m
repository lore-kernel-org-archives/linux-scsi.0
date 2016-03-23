From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 00/23] ncr5380: Eliminate macros, reduce code duplication, fix bugs etc
Date: Wed, 23 Mar 2016 16:54:26 -0400
Message-ID: <yq1mvpo29vh.fsf@sermon.lab.mkp.net>
References: <20160323101009.341929635@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160323101009.341929635@telegraphics.com.au> (Finn Thain's
	message of "Wed, 23 Mar 2016 21:10:09 +1100")
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn,

Finn> This patch series has been tested on several platforms. I tested
Finn> the dmx3191d and mac_scsi modules on suitable hardware, Michael
Finn> tested atari_scsi on an Atari Falcon and Ondrej has tested
Finn> g_NCR5380 and g_NCR5380_mmio on various ISA cards.

Applied to 4.7/scsi-queue.

And thanks for re-posting with all the relevant tags applied. Much
appreciated!

-- 
Martin K. Petersen	Oracle Linux Engineering
