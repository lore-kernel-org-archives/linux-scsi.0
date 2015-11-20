From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 20 Nov 2015 11:38:30 -0500
Message-ID: <yq1ziy8mxrt.fsf@sermon.lab.mkp.net>
References: <4355540.BF55dNX7U7@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4355540.BF55dNX7U7@wuerfel> (Arnd Bergmann's message of "Thu, 19
	Nov 2015 15:22:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The advansys drvier uses the request_dma function that is used on
Arnd> ISA machines for the internal DMA controller, which causes build
Arnd> errors on platforms that have ISA slots but do not provide the ISA
Arnd> DMA API:

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
