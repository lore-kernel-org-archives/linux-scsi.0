From: adam radford <aradford@gmail.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
Date: Wed, 1 Sep 2010 17:25:06 -0700
Message-ID: <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
	<AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
	<alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
	<alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
	<alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
	<alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
	<alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
	<alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 1, 2010 at 2:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Could the lock/unlock be causing the issue?
> Again, in 2.6.34, there are no latency problems or controller resets.

Justin,

We are looking into this issue and should get back to you soon.

The lock/unlock() kernel calls were not added by me but were part of a
series of 'BKL pushdown' patches added by someone to all drivers with
an ioctl interface.  If you think those might be related to your
issue, you could try
removing those 2 lines of code and recompiling.

If you haven't already, please email you kernel .config files for both
the working kernel and non working kernel to the 3ware/LSI support
people you are in contact with.

Thanks.

-Adam
