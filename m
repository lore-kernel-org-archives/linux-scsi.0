From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] fdomain: Resurrect driver (modular version)
Date: Mon, 29 Apr 2019 17:35:28 -0400
Message-ID: <yq1imuwxzof.fsf@oracle.com>
References: <20190428200626.28092-1-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190428200626.28092-1-linux@zary.sk> (Ondrej Zary's message of
        "Sun, 28 Apr 2019 22:06:22 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: Rik Faith <faith@cs.unc.edu>, "David A . Hinds" <dahinds@users.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Ondrej,

> Resurrect previously removed fdomain driver, in modern style.
> Initialization is rewritten completely, with support for multiple
> cards, no more global state variables.  Most of the code from
> interrupt handler is moved to a workqueue.
>
> This is a modularized version with core separated from bus-specific
> drivers (PCI, ISA and PCMCIA). Only PCI driver is tested for now.

I applied patches #1(v2) and #2 to 5.2/scsi-queue with a few tweaks.

Thanks for your work on this!

-- 
Martin K. Petersen	Oracle Linux Engineering
