From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?=
        <kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: fix blk_get_queue usage
Date: Tue, 1 Aug 2017 22:19:18 +0300
Message-ID: <4591551F-0CD1-4121-8972-D94D5DEE4A63@kolumbus.fi>
References: <1501591374-11229-1-git-send-email-hare@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs24.mail.saunalahti.fi ([62.142.117.201]:35652 "EHLO
        vs24.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbdHAT1X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 15:27:23 -0400
In-Reply-To: <1501591374-11229-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Hannes Reinecke <hare@suse.com>


> On 1 Aug 2017, at 15.42, Hannes Reinecke <hare@suse.de> wrote:
> 
> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> 
> If blk_queue_get() in st_probe fails, disk->queue must not
> be set to SDp->request_queue, as that would result in
> put_disk() dropping a not taken reference.
> 
> Thus, disk->queue should be set only after a successful
> blk_queue_get().
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
