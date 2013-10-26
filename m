From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH v2 0/10] IB SRP initiator patches for kernel 3.13
Date: Sat, 26 Oct 2013 12:28:14 -0400
Message-ID: <1382804894.7223.0.camel@haswell.thedillows.org>
References: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526BB5AC.7010601-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-10-26 at 14:29 +0200, Bart Van Assche wrote:
> The changes since the previous version of this patch series are as follows
> (see also http://thread.gmane.org/gmane.linux.drivers.rdma/17693):
> - Renamed the "can_queue" parameter into "queue_size".
> - Corrected the title of the introductory e-mail - changed kernel version
>   "3.12" into "3.13".
> - Corrected the description of /sys/class/srp_remote_ports/port-<h>:<n>/state.
> - Corrected sysfs kernel version and date for the newly introduced sysfs
>   attributes.
> - Fixed a hard to trigger race condition that could be triggered only with
>   identical values of reconnect_delay and fast_io_fail_tmo and that could
>   cause failback not to occur (see also rport_fast_io_fail_timedout()). Note:
>   I don't think it's useful for anyone to set reconnect_delay identical to
>   fast_io_fail_tmo.

Looks good to me, thanks for the inter-diff.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
