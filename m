From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v7 0/8] mpt3sas: some bug fixes patches
Date: Fri, 2 Nov 2018 20:35:38 +0200
Message-ID: <CAHp75VcrMhBZd7LajwbFD=YA3jA=7a1SQKRHmocG600=fr9YOw@mail.gmail.com>
References: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <5bdc96b6a91b2_2e7982af9fe8650b0ba@bhelgaas-glaptop.notmuch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bdc96b6a91b2_2e7982af9fe8650b0ba@bhelgaas-glaptop.notmuch>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 2, 2018 at 8:26 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> Suganath Prabu wrote:
> > V7 Change Set:
> > Split some patches into multiple small patches
> > as suggested by Bjorn Helgaas
> >
> > v6 Change Set:
> > Incorporated changes as suggested by Andy.
> > In Patch 1 converted while loop to do while in
> > function mpt3sas_wait_for_ioc_to_operational().
> > And in patch 3 removed parentheses.
> >
> > V5 Change Set:
> > V5 post has only defect fixes.
> > We are reworking and incorporating the suggestions from Bjorn.
> > And after covering tests, we ll be post Hot-Plug Surprise
> >  removal patches.
> >
> > V4 Change Set:
> > Reframe split strings in print statement, to avoid
> >
> > V3 Change Set:
> > Simplified function "mpt3sas_base_pci_device_is_available" and
> > made inline
> >
> > V2 Change Set:
> > Replaced mpt3sas_base_pci_device_is_unplugged with
> > pci_device_is_present.
> >
> > V1 Chnage Set:
> > In Patch 0001 - unlock mutex, if active reset is in progress.
> >
> > Suganath Prabu (8):
> >   mpt3sas: Added new #define variable IOC_OPERATIONAL_WAIT_COUNT
> >   mpt3sas: Separate out mpt3sas_wait_for_ioc
> >   mpt3sas: Refactor mpt3sas_wait_for_ioc function
> >   mpt3sas: Call sas_remove_host before removing the target devices
> >   mpt3sas: Fix Sync cache command failure during driver unload
> >   mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA devices
> >   mpt3sas: Fix driver modifying persistent data in Manufacturing page11
> >   mpt3sas: Bump driver version to 27.100.00.00.
> >
> >  drivers/scsi/mpt3sas/mpt3sas_base.c      | 73 +++++++++++++------------
> >  drivers/scsi/mpt3sas/mpt3sas_base.h      |  8 ++-
> >  drivers/scsi/mpt3sas/mpt3sas_config.c    | 27 ++--------
> >  drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++------
> >  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 38 ++++++++++++-
> >  drivers/scsi/mpt3sas/mpt3sas_transport.c | 91 ++++++--------------------------
> >  6 files changed, 106 insertions(+), 152 deletions(-)
> >
> > --
> > 1.8.3.1
>
> These all look fine to me.  I'm only looking at the code structure; I
> have no idea how the mpt3sas hardware or the SCSI mid-layer work, so
> you're on your own there :)
>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
>
> Andy also gave his reviewed-by on the v6 series, so I cc'd him here.
> I think it's good practice to specifically cc anybody who has
> commented on previous versions of your patch set.

Right, thanks!

With the same caveat as Bjorn posted I give my

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

to v7.


-- 
With Best Regards,
Andy Shevchenko
