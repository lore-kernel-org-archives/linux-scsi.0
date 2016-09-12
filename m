From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Mon, 12 Sep 2016 14:13:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1609121412160.20106-100000@netrider.rowland.org>
References: <1473686381-17259-1-git-send-email-oneukum@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34617 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754058AbcILSNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2016 14:13:10 -0400
In-Reply-To: <1473686381-17259-1-git-send-email-oneukum@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, gregKH@linuxfoundation.org

On Mon, 12 Sep 2016, Oliver Neukum wrote:

> Some SATA to USB bridges fail to cooperate with some
> drives resulting in no cache being present being reported
> to the host. That causes the host to skip sending
> a command to synchronize caches. That causes data loss
> when the drive is powered down.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  Documentation/kernel-parameters.txt | 2 ++
>  drivers/usb/storage/scsiglue.c      | 8 ++++++++
>  drivers/usb/storage/unusual_devs.h  | 7 +++++++
>  drivers/usb/storage/usb.c           | 6 +++++-
>  include/linux/usb_usual.h           | 2 ++
>  5 files changed, 24 insertions(+), 1 deletion(-)

