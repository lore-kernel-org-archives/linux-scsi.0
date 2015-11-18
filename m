From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, resend] scsi: advansys: fix big-endian builds
Date: Wed, 18 Nov 2015 10:18:30 -0500
Message-ID: <yq1mvubs5dl.fsf@sermon.lab.mkp.net>
References: <4411376.blKgWIg75B@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4411376.blKgWIg75B@wuerfel> (Arnd Bergmann's message of "Mon, 16
	Nov 2015 17:49:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: James Bottomley <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Matthew Wilcox <willy@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Building the advansys driver in a big-endian configuration such as
Arnd> ARM allmodconfig shows a warning:

Applied to 4.4.

-- 
Martin K. Petersen	Oracle Linux Engineering
