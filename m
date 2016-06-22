From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: wd7000: print sector number as 64-bit
Date: Tue, 21 Jun 2016 22:22:23 -0400
Message-ID: <yq1bn2u2c9s.fsf@sermon.lab.mkp.net>
References: <20160621090249.774301-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160621090249.774301-1-arnd@arndb.de> (Arnd Bergmann's message
	of "Tue, 21 Jun 2016 11:02:39 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Enabling format checking in dprintk() shows that wd7000_biosparam
Arnd> uses an incorrect format string for sector_t:

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
