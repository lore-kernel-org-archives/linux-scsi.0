From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 01/12] scsi_transport_srp: Introduce
 srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 02:37:19 -0700
Message-ID: <20150430093719.GA23486@infradead.org>
References: <5541EE21.3050809@sandisk.com>
 <5541EE4A.30803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5541EE4A.30803-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2015 at 10:56:42AM +0200, Bart Van Assche wrote:
> Introduce the helper function srp_wait_for_queuecommand().
> Move the definition of scsi_request_fn_active(). This patch
> does not change any functionality. A second call to
> scsi_wait_for_queuecommand() will be introduced in the next
> patch.

Can we take a step back here?

This isn;t something driver should be doing, so we really should take
care of this in the SCSI midlayer.

Especially given that we don't maintain request_fn_active for blk-mq.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
