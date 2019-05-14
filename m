From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] fdomain: Resurrect driver
Date: Tue, 14 May 2019 13:37:09 -0400
Message-ID: <yq1r291c4ze.fsf@oracle.com>
References: <20190514172309.12874-1-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514172309.12874-1-linux@zary.sk> (Ondrej Zary's message of
        "Tue, 14 May 2019 19:23:06 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ondrej,

> Resurrect previously removed fdomain driver, in modern style.
> Initialization is rewritten completely, with support for multiple
> cards, no more global state variables.  Most of the code from
> interrupt handler is moved to a workqueue.
>
> This is a modularized version with core separated from bus-specific
> drivers (PCI, ISA and PCMCIA). Only PCI and ISA drivers are submitted
> for now.

Applied to 5.3/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
