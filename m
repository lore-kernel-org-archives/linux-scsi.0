From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
        <mikhail.v.gavrilov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Please help me with kernel hung
Date: Wed, 26 Jul 2017 01:24:23 +0500
Message-ID: <CABXGCsP=Lgw+pB4Hktqq-dt-eg+rBLuyZ7ECjZhPFaMNdXDDNg@mail.gmail.com>
References: <CABXGCsMEYeiK5+dVVGb9oGaE0Ua=U_BN9a_FdR_BD6ZBBmX1qA@mail.gmail.com>
 <Pine.LNX.4.44L0.1707241706060.1739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1707241706060.1739-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 25 July 2017 at 02:12, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> This is enough for now.  The problem is that a USB transfer is started
> but never stopped, which indicates a problem with the host controller.
>
> In this case you're using an xHCI host controller.  Unfortunately the
> xHCI maintainer is on vacation, so he won't be able to help for a
> while.
>
> In the meantime, you could try doing a git bisection to find which
> commit caused the problem to occur.
>
> Alan Stern
>

Sorry, I am afraid I can't bisect because i don't know how triggering
this issue again.
It means that I already several times rebooted after this and machine not hung.

But still occurs another problem that reproducible more successful
when I run KVM virtual machine and run inside kernel compilation then
host hung without any records in journalctl log. It's really annoying
because I don't know who is culprit here. Can here helps bisect?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
