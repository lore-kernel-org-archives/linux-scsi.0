From: David Dillow <dad-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 0/8] IB SRP initiator patches for kernel 3.12
Date: Mon, 09 Sep 2013 22:53:18 -0400
Message-ID: <1378781598.3794.1.camel@feather.ornl.gov>
References: <521363EA.8080906@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521363EA.8080906-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-08-20 at 14:41 +0200, Bart Van Assche wrote:
> Changes since the previous patch series are:
> - Rewrote the srp_tmo_valid() to improve readability (requested by Dave
>    Dillow).
> - The combination (reconnect_delay < 0 && fast_io_fail_tmo < 0 &&
>    dev_loss_tmo < 0) is now rejected as requested by Dave Dillow.
> - Fixed a race between transport layer failure handling and device
>    removal. This issue was reported by Vu Pham.

For patches 1-6,

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
