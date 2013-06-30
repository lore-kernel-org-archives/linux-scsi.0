From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 06/15] IB/srp: Maintain a single connection per I_T
 nexus
Date: Sun, 30 Jun 2013 16:10:22 -0400
Message-ID: <1372623022.12468.12.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD86CE.8080804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD86CE.8080804-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-06-28 at 14:51 +0200, Bart Van Assche wrote:
> An SRP target is required to maintain a single connection between
> initiator and target. This means that if the 'add_target' attribute
> is used to create a second connection to a target that the first
> connection will be logged out and that the SCSI error handler will
> kick in. The SCSI error handler will cause the SRP initiator to
> reconnect, which will cause I/O over the second connection to fail.
> Avoid such ping-pong behavior by disabling relogins. Note: if
> reconnecting manually is necessary, that is possible by deleting
> and recreating an rport via sysfs.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
