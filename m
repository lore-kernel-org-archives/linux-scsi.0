From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: aacraid: avoid open-coded upper_32_bits
Date: Tue, 07 Feb 2017 17:25:51 -0500
Message-ID: <yq1a89xprio.fsf@oracle.com>
References: <20170207125948.490095-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207125948.490095-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 7 Feb 2017 13:59:30 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Dave Carroll <David.Carroll@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Shifting a dma_addr_t right by 32 bits causes a compile-time
Arnd> warning when that type is only 32 bit wide:

Arnd> drivers/scsi/aacraid/src.c: In function 'aac_src_start_adapter':
Arnd> drivers/scsi/aacraid/src.c:414:29: error: right shift count >=
Arnd> width of type [-Werror=shift-count-overflow]

Arnd> This changes the driver to use the predefined macros consistently,
Arnd> including one correct but open-coded upper_32_bits() instance.

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
