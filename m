From: Sam Protsenko <semen.protsenko@linaro.org>
Subject: Re: [PATCH v2] codafs: Fix build using bare-metal toolchain
Date: Tue, 30 Oct 2018 20:33:28 +0200
Message-ID: <CAKaJLVvXUTB5hyoRPZpfnzFKiLrCfLmras_37B5JxSYs4438Tg@mail.gmail.com>
References: <20181029200311.16947-1-semen.protsenko@linaro.org>
 <CAKaJLVvpNZW2a+3xc7PE0+iU1nm39A7PEjCu8F9ijrT+wEXOag@mail.gmail.com>
 <20181030063408.GA26627@kroah.com> <CAKaJLVtT+pFzOBjybAXmOC0mJyN=BHavsfAYEzgSWn-i7UYEjA@mail.gmail.com>
 <20181030130401.3ab5gl4fsvpa2fes@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181030130401.3ab5gl4fsvpa2fes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, Praneeth Bajjuri <praneeth@ti.com>, linux-kernel@vger.kernel.org, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 30, 2018 at 3:04 PM, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> On Tue, Oct 30, 2018 at 02:01:04PM +0200, Sam Protsenko wrote:
>> On Tue, Oct 30, 2018 at 8:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > On Mon, Oct 29, 2018 at 10:05:49PM +0200, Sam Protsenko wrote:
>> >> Hi Greg,
>> >>
>> >> On Mon, Oct 29, 2018 at 10:03 PM, Sam Protsenko
>> >> <semen.protsenko@linaro.org> wrote:
>> >> > The kernel is self-contained project and can be built with bare-metal
>> >> > toolchain. But bare-metal toolchain doesn't define __linux__. Because of
>> >> > this u_quad_t type is not defined when using bare-metal toolchain and
>> >> > codafs build fails. This patch fixes it by defining u_quad_t type
>> >> > unconditionally.
>> >> >
>> >> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
>> >> > ---
>> >>
>> >> Can you please pull this one, if this applicable? I sent it a while
>> >> ago, but I guess it got lost in mailing list. It might be also
>> >> applicable to stable branch (as it fixes allmodconfig build for ARM
>> >> with bare-metal toolchain).
>> >
>> > Why are you asking me?  I'm not the maintainer of this file :(
>> >
>> > confused,
>> >
>>
>> Sorry to bother you. I just thought you might be interested in this
>> one, as it fixes build for "allmodconfig" configuration, hence it can
>> be related to stable branch. Also, maintainers didn't respond to that
>> patch, so I'm kinda dead in the water.
>>
>> Anyway, will try to ping maintainers one more time.
>
> I thought I had responded, I didn't see a reason why one would want to
> compile non-userspace kernel headers outside of the context of the
> kernel and if you do have to do that why not just add -D__linux__.
>
> However, I can also see the point that anything not in uapi/ pretty much
> by definition will be compiled with __linux__ defined so it actually
> doesn't make a discernable difference to just drop the ifdef and I'm
> fine with a patch like this.
>
> These trivial patches typically get picked up through kernel janitors,
> or maybe an akpm linux-next patch queue. In fact, I'm not even sure if
> there is a designated person I would be passing updates to, I've sent
> patches to akpm, viro, hellwig, linus, and gregkh at various times.
>
> Jan


Hi Jan,

Thank you for the reply. Good point, I will try to re-send this one to
Andrew Morton and kernel-janitors.

P.S. We need this patch for fixing LKFT/ci-loops build.

Thanks!
