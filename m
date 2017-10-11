From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libiscsi: fix shifting of DID_REQUEUE host byte
Date: Wed, 11 Oct 2017 13:34:25 -0400
Message-ID: <yq14lr5h9lq.fsf@oracle.com>
References: <20171009113319.9505-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171009113319.9505-1-jthumshirn@suse.de> (Johannes Thumshirn's
        message of "Mon, 9 Oct 2017 13:33:19 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Chris Leech <cleech@redhat.com>
List-Id: linux-scsi@vger.kernel.org


Johannes,

> The SCSI host byte should be shifted left by 16 in order to have
> scsi_decide_disposition() do the right thing (.i.e. requeue the
> command).

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
