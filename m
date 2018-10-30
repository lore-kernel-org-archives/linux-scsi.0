From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH v2] codafs: Fix build using bare-metal toolchain
Date: Tue, 30 Oct 2018 14:01:04 +0200
Message-ID: <CAKaJLVtT+pFzOBjybAXmOC0mJyN=BHavsfAYEzgSWn-i7UYEjA@mail.gmail.com>
References: <20181029200311.16947-1-semen.protsenko@linaro.org>
 <CAKaJLVvpNZW2a+3xc7PE0+iU1nm39A7PEjCu8F9ijrT+wEXOag@mail.gmail.com> <20181030063408.GA26627@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030063408.GA26627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Andy Shevchenko <andy.shevchenko@gmail.com>, Praneeth Bajjuri <praneeth@ti.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 30, 2018 at 8:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 29, 2018 at 10:05:49PM +0200, Sam Protsenko wrote:
>> Hi Greg,
>>
>> On Mon, Oct 29, 2018 at 10:03 PM, Sam Protsenko
>> <semen.protsenko@linaro.org> wrote:
>> > The kernel is self-contained project and can be built with bare-metal
>> > toolchain. But bare-metal toolchain doesn't define __linux__. Because of
>> > this u_quad_t type is not defined when using bare-metal toolchain and
>> > codafs build fails. This patch fixes it by defining u_quad_t type
>> > unconditionally.
>> >
>> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
>> > ---
>>
>> Can you please pull this one, if this applicable? I sent it a while
>> ago, but I guess it got lost in mailing list. It might be also
>> applicable to stable branch (as it fixes allmodconfig build for ARM
>> with bare-metal toolchain).
>
> Why are you asking me?  I'm not the maintainer of this file :(
>
> confused,
>

Sorry to bother you. I just thought you might be interested in this
one, as it fixes build for "allmodconfig" configuration, hence it can
be related to stable branch. Also, maintainers didn't respond to that
patch, so I'm kinda dead in the water.

Anyway, will try to ping maintainers one more time.

> greg k-h
