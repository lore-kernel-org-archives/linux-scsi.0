From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] SCSI: fcoe: convert to use BUS_ATTR_WO
Date: Tue, 29 Jan 2019 00:30:10 -0500
Message-ID: <yq1d0ogf2u5.fsf@oracle.com>
References: <20190122142735.GB18225@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122142735.GB18225@kroah.com> (Greg Kroah-Hartman's message
        of "Tue, 22 Jan 2019 15:27:35 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Greg,

> We are trying to get rid of BUS_ATTR() and the usage of that in the
> fcoe driver can be trivially converted to use BUS_ATTR_WO(), so use
> that instead.

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
