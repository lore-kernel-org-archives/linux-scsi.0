From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 0/10] IB SRP initiator patches for kernel 3.12
Date: Fri, 25 Oct 2013 18:14:42 -0400
Message-ID: <1382739282.17280.4.camel@frustration.ornl.gov>
References: <52569806.9080201@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569806.9080201-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-10-10 at 14:05 +0200, Bart Van Assche wrote:
> The purpose of this InfiniBand SRP initiator patch series is as follows:
> - Make the SRP initiator driver better suited for use in a H.A. setup.
>    Add fast_io_fail_tmo, dev_loss_tmo and reconnect_delay parameters.
>    With the default values of these parameters failover happens
>    significantly faster. The dev_loss mechanism can be disabled which
>    makes it possible to avoid device removal which is necessary when
>    e.g. using initiator side mirroring.
> - Improve performance by making the queue size configurable.
> - Make it possible to figure out which SCSI host corresponds to which
>    SRP initiator port by making the SGID (source GID) available in sysfs.

Many of these already have it, but for patches 1-10:

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
