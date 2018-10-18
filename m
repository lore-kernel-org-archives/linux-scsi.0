From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [v5 3/4] mpt3sas:Fix driver modifying persistent data.
Date: Thu, 18 Oct 2018 12:46:29 +0530
Message-ID: <CA+RiK66upf=E-LWSknA-xK4G=y+2OiqT1zUpvQAJ=aYz1yWHtw@mail.gmail.com>
References: <1539755947-27014-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1539755947-27014-4-git-send-email-suganath-prabu.subramani@broadcom.com> <CAHp75Vf2HMj-DBU7TPEM2=g=XdzksnMgCvzCU6BQa9W8XJmPKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vf2HMj-DBU7TPEM2=g=XdzksnMgCvzCU6BQa9W8XJmPKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: helgaas@kernel.org, lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, Oliver <oohall@gmail.com>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 1:54 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Wed, Oct 17, 2018 at 8:59 AM Suganath Prabu
> <suganath-prabu.subramani@broadcom.com> wrote:
> >
> > * If EEDPTagMode field in manufacturing page11 is set,
> > unset it. This is needed to fix a hardware bug
> > in SAS3/SAS2 cards, So, skipping EEDPTagMode changes
> > in Manufacturing page11 for SAS35 controllers.
> >
> > * Fix driver modifying NVRAM/persistent data in
> > Manufacturing page11 along with current copy. Driver should
> > change only current copy of Manufacturing page11.
>
> > -       if (ioc->manu_pg11.EEDPTagMode == 0) {
> > +       if ((!ioc->is_gen35_ioc) && (ioc->manu_pg11.EEDPTagMode == 0)) {
>
> No need to have parens.
>
Yes, We ll remove parentheses in v6 patch set.
Thanks,
>
> --
> With Best Regards,
> Andy Shevchenko
