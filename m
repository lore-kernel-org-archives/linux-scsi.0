From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_sysfs.c: Hide wwid sdev attr if VPD is not supported
Date: Tue, 18 Jun 2019 23:35:16 -0400
Message-ID: <yq1muieuu17.fsf@oracle.com>
References: <20190612020828.8140-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612020828.8140-1-marcos.souza.org@gmail.com> (Marcos Paulo
        de Souza's message of "Tue, 11 Jun 2019 23:08:28 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org


Marcos,

> WWID composed from VPD data from device, specifically page 0x83. So,
> when a device does not have VPD support, for example USB storage
> devices where VPD is specifically disabled, a read into <blk
> device>/device/wwid file will always return ENXIO. To avoid this,
> change the scsi_sdev_attr_is_visible function to hide wwid sysfs file
> when the devices does not support VPD.

Not a big fan of attribute files that come and go.

Why not just return an empty string? Hannes?

-- 
Martin K. Petersen	Oracle Linux Engineering
