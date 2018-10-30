From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [v6 0/4] mpt3sas: Hot-Plug Surprise removal support on IOC.
Date: Tue, 30 Oct 2018 15:05:23 +0200
Message-ID: <CAHp75VeNSG7=79pQ=9zFkp0mSSSoFnjacbQQa=kQu2+hKWvMwQ@mail.gmail.com>
References: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <CA+RiK64Y=FLr=SZmxEoCvWCvZq8ppqFsL=q2L1Q7T5sZfDQfkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+RiK64Y=FLr=SZmxEoCvWCvZq8ppqFsL=q2L1Q7T5sZfDQfkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Lukas Wunner <lukas@wunner.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, ruscur@russell.cc, sbobroff@linux.ibm.com, Oliver <oohall@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 30, 2018 at 8:41 AM Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
>
> Any update on this ?
> In V6, I have posted has only defect fixes (Other than HBA Hot-Plug
> Surprise remove support).
>
> We are reworking and incorporating the suggestions from Bjorn.
> And after covering tests, we ll post Hot-Plug Surprise removal patches.
>

FWIW,
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

P.S. We are in the middle of merge window, so, this week is a little
chance anyone will look at it.

> Thanks,
> Suganath Prabu
> On Tue, Oct 23, 2018 at 3:51 PM Suganath Prabu
> <suganath-prabu.subramani@broadcom.com> wrote:
> >
> > v6 Change set:
> > Incorporated changes as suggested by Andy.
> > In Patch 1 converted while loop to do while in
> > function mpt3sas_wait_for_ioc_to_operational().
> > And in patch 3 removed parentheses.
> >
> > V5 Change set:
> > V5 post has only defect fixes.
> > We are reworking and incorporating the suggestions from Bjorn.
> > And after covering tests, we ll be post Hot-Plug Surprise
> >  removal patches.
> >
> > V4 Change set:
> > Reframe split strings in print statement, to avoid
> >
> > V3 Change Set:
> > Simplified function "mpt3sas_base_pci_device_is_available" and
> > made inline
> >
> > V2 changes:
> > Replaced mpt3sas_base_pci_device_is_unplugged with
> > pci_device_is_present.
> >
> > V1 changes:
> > In Patch 0001 - unlock mutex, if active reset is in progress.
> > Suganath Prabu (4):
> >   mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
> >   mpt3sas: Fix Sync cache command failure during driver unload
> >   mpt3sas:Fix driver modifying persistent data.
> >   mpt3sas: Bump driver version to 27.100.00.00.
> >
> >  drivers/scsi/mpt3sas/mpt3sas_base.c      | 75 ++++++++++++++++++--------------
> >  drivers/scsi/mpt3sas/mpt3sas_base.h      |  8 +++-
> >  drivers/scsi/mpt3sas/mpt3sas_config.c    | 28 +++---------
> >  drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++-------
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 38 +++++++++++++++-
> >  drivers/scsi/mpt3sas/mpt3sas_transport.c | 70 ++++++-----------------------
> >  6 files changed, 106 insertions(+), 134 deletions(-)
> >
> > --
> > 1.8.3.1
> >



-- 
With Best Regards,
Andy Shevchenko
