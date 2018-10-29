From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] codafs: Fix build using bare-metal toolchain
Date: Mon, 29 Oct 2018 22:08:43 +0200
Message-ID: <CAHp75VdWYkPyLvDfYt+8tF2KSR6uH0nLM5R-n=OafXTPOWgpDw@mail.gmail.com>
References: <20181029200311.16947-1-semen.protsenko@linaro.org> <CAKaJLVvpNZW2a+3xc7PE0+iU1nm39A7PEjCu8F9ijrT+wEXOag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKaJLVvpNZW2a+3xc7PE0+iU1nm39A7PEjCu8F9ijrT+wEXOag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sam Protsenko <semen.protsenko@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, codalist@coda.cs.cmu.edu, coda@cs.cmu.edu, Praneeth Bajjuri <praneeth@ti.com>
List-Id: linux-scsi@vger.kernel.org

Cc: Arnd, I guess it might be useful for kernel-ci activity as well.

On Mon, Oct 29, 2018 at 10:05 PM Sam Protsenko
<semen.protsenko@linaro.org> wrote:
>
> Hi Greg,
>
> On Mon, Oct 29, 2018 at 10:03 PM, Sam Protsenko
> <semen.protsenko@linaro.org> wrote:
> > The kernel is self-contained project and can be built with bare-metal
> > toolchain. But bare-metal toolchain doesn't define __linux__. Because of
> > this u_quad_t type is not defined when using bare-metal toolchain and
> > codafs build fails. This patch fixes it by defining u_quad_t type
> > unconditionally.
> >
> > Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> > ---
>
> Can you please pull this one, if this applicable? I sent it a while
> ago, but I guess it got lost in mailing list. It might be also
> applicable to stable branch (as it fixes allmodconfig build for ARM
> with bare-metal toolchain).
>
> Thanks!
>
> >  include/linux/coda.h | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/include/linux/coda.h b/include/linux/coda.h
> > index d30209b9cef8..0ca0c83fdb1c 100644
> > --- a/include/linux/coda.h
> > +++ b/include/linux/coda.h
> > @@ -58,8 +58,7 @@ Mellon the rights to redistribute these changes without encumbrance.
> >  #ifndef _CODA_HEADER_
> >  #define _CODA_HEADER_
> >
> > -#if defined(__linux__)
> >  typedef unsigned long long u_quad_t;
> > -#endif
> > +
> >  #include <uapi/linux/coda.h>
> >  #endif
> > --
> > 2.19.1
> >



-- 
With Best Regards,
Andy Shevchenko
