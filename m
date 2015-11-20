From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [RESEND 2] SCSI: initio: remove duplicate module device table
Date: Fri, 20 Nov 2015 11:39:31 -0500
Message-ID: <yq1vb8wmxq4.fsf@sermon.lab.mkp.net>
References: <5318263.D61echQrl2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5318263.D61echQrl2@wuerfel> (Arnd Bergmann's message of "Thu, 19
	Nov 2015 15:33:41 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, jbottomley@odin.com, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The initio driver has for many years had two copies of the same
Arnd> module device table. One of them is also used for registering the
Arnd> other driver, the other one is entirely useless after the large
Arnd> scale cleanup that Alan Cox did back in 2007.

Applied.

-- 
Martin K. Petersen	Oracle Linux Engineering
