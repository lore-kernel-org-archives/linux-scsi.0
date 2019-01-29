From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: fcoe: remove unneeded fcoe_ctlr_destroy_store export
Date: Tue, 29 Jan 2019 00:31:17 -0500
Message-ID: <yq18sz4f2sa.fsf@oracle.com>
References: <20190122142818.GC18225@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122142818.GC18225@kroah.com> (Greg Kroah-Hartman's message
        of "Tue, 22 Jan 2019 15:28:18 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Greg,

> There's no need to export fcoe_ctlr_destroy_store as a symbol, so remove
> the EXPORT_SYMBOL() line for it.

Applied to 5.1/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
