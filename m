From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: mptfusion: Remove unnecessary parentheses and
 simplify null checks
Date: Tue, 2 Oct 2018 08:07:04 -0700
Message-ID: <20181002150704.GA444@flashbox>
References: <20180915063645.31295-1-natechancellor@gmail.com>
 <CAK8P3a3PaWgieA0_HBJJ-FVeBO+iAdN8_kv5YUbpKURJ3gsoaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3PaWgieA0_HBJJ-FVeBO+iAdN8_kv5YUbpKURJ3gsoaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2018 at 02:58:21PM +0200, Arnd Bergmann wrote:
> On Sat, Sep 15, 2018 at 8:38 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> 
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/message/fusion/mptbase.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> > index dc1e43a02599..ba551d8dfba4 100644
> > --- a/drivers/message/fusion/mptbase.c
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -335,11 +335,11 @@ static int mpt_remove_dead_ioc_func(void *arg)
> >         MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
> >         struct pci_dev *pdev;
> >
> > -       if ((ioc == NULL))
> > +       if (!ioc)
> >                 return -1;
> >
> >         pdev = ioc->pcidev;
> > -       if ((pdev == NULL))
> > +       if (!pdev)
> >                 return -1;
> >
> >         pci_stop_and_remove_bus_device_locked(pdev);
> > --
> 
> 
> The exact same code also exists in drivers/scsi/mpt3sas/. I had a similar
> patch for both drivers, but saw that yours now got merged for fusion.
> 
> If you don't mind, could you fix mpt3sas_base.c the same way?
> 
>      Arnd

Hi Arnd,

I did sent a patch for this a little bit later: https://lore.kernel.org/lkml/20180920201002.23979-1-natechancellor@gmail.com/

I am still waiting for it to be merged.

Thanks!
Nathan
