From: "'Dave Olien'" <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Wed, 13 Oct 2004 14:46:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041013214629.GA30273@osdl.org>
References: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:40850 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S269862AbUJMVqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 17:46:40 -0400
Content-Disposition: inline
In-Reply-To: <53CF1076699CD711B7DD0002A51363F1072A6E3A@exw-ks.ks.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Qi, Yanling" <yanling.qi@engenio.com>
Cc: Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@SteelEye.com>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


Yanling,

Your reply makes sense.  So, the controller fails SCSI commands
with this sense key while it is transferring a volume.

Are the failed commands only for the volume that is being
transferred, or will it fail any command queued to that
controller while it is doing a transfer.

Now, on to figuring out why some of these requeued commands
fail the requeue.

Thanks!
Dave

On Wed, Oct 13, 2004 at 01:15:40PM -0500, Qi, Yanling wrote:
> The check-condition (06h/8Bh/02h) is Engenio's vendor specific UA. It means
> "Quiescence Is In Progress" while transferring a volume from one controller
> to the other. When the volume transfer (cache sync and bookkeeping) is
> completed, the device server will start accept IO requests.
> 
> Yanling
> 
