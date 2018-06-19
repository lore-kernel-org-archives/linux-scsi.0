From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi: remove Scsi_Cmnd typedef
Date: Mon, 18 Jun 2018 22:06:55 -0400
Message-ID: <yq1wouvil6o.fsf@oracle.com>
References: <20180613075349.7509-1-jthumshirn@suse.de>
        <20180613075349.7509-2-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613075349.7509-2-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Wed, 13 Jun 2018 09:53:47 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> This will make subsequent refactoring easier to handle.

So much yes!

Applied to 4.19/scsi-queue. Please fix up patches 2 and 3.

-- 
Martin K. Petersen	Oracle Linux Engineering
