From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Please help me with kernel hung
Date: Tue, 25 Jul 2017 17:07:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707251706490.1605-100000@iolanthe.rowland.org>
References: <CABXGCsP=Lgw+pB4Hktqq-dt-eg+rBLuyZ7ECjZhPFaMNdXDDNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43176 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752269AbdGYVHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2017 17:07:33 -0400
In-Reply-To: <CABXGCsP=Lgw+pB4Hktqq-dt-eg+rBLuyZ7ECjZhPFaMNdXDDNg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 26 Jul 2017, Михаил Гаврилов wrote:

> On 25 July 2017 at 02:12, Alan Stern <stern@rowland.harvard.edu> wrote:
> > This is enough for now.  The problem is that a USB transfer is started
> > but never stopped, which indicates a problem with the host controller.
> >
> > In this case you're using an xHCI host controller.  Unfortunately the
> > xHCI maintainer is on vacation, so he won't be able to help for a
> > while.
> >
> > In the meantime, you could try doing a git bisection to find which
> > commit caused the problem to occur.
> >
> > Alan Stern
> >
> 
> Sorry, I am afraid I can't bisect because i don't know how triggering
> this issue again.
> It means that I already several times rebooted after this and machine not hung.
> 
> But still occurs another problem that reproducible more successful
> when I run KVM virtual machine and run inside kernel compilation then
> host hung without any records in journalctl log. It's really annoying
> because I don't know who is culprit here. Can here helps bisect?

I don't know.  Try it and see.

Alan Stern
