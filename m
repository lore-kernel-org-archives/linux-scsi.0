From: Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH] drivers: ufs: Add missing MODULE_* information
Date: Thu, 21 Mar 2019 14:21:06 +0100
Message-ID: <CADYN=9LX9opLm9_zJ-NMkRqTW4H=waQCkq-te5CGkLgri3fgog@mail.gmail.com>
References: <20190321125034.22697-1-anders.roxell@linaro.org> <1553174301.30977.85.camel@mtkswgap22>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553174301.30977.85.camel@mtkswgap22>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanley Chu <stanley.chu@mediatek.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, Matthias Brugger <matthias.bgg@gmail.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-mediatek@lists.infradead.org, peter.wang@mediatek.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Mar 2019 at 14:18, Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Hi Anders,
>
> On Thu, 2019-03-21 at 13:50 +0100, Anders Roxell wrote:
> > When building the ufs-mediatek module the following warning shows up:
> >
> > WARNING: modpost: missing MODULE_LICENSE() in
> >   drivers/scsi/ufs/ufs-mediatek.o
> >
> > Rework to add MODULE_LICENSE,MODULE_AUTHOR and MODULE_DESCRIPTION.
> >
> > Fixes: ddd90623ce26 ("scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips")
> > Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> > ---
> >  drivers/scsi/ufs/ufs-mediatek.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> > index c3b78fc83d3f..ce4767784937 100644
> > --- a/drivers/scsi/ufs/ufs-mediatek.c
> > +++ b/drivers/scsi/ufs/ufs-mediatek.c
> > @@ -364,4 +364,9 @@ static struct platform_driver ufs_mtk_pltform = {
> >       },
> >  };
> >
> > +MODULE_AUTHOR("Stanley Chu <stanley.chu@mediatek.com>");
> > +MODULE_AUTHOR("Peter Wang <peter.wang@mediatek.com>");
> > +MODULE_DESCRIPTION("Mediatek UFS Driver");
>
> Thanks for sending this.
>
> Could you fix it as "MediaTek UFS Host Driver" ?

Yes, I'll update it and sending out a v2 shortly.

Cheers,
Anders

>
> > +MODULE_LICENSE("GPL v2");
> > +
> >  module_platform_driver(ufs_mtk_pltform);
>
> Thanks,
> Stanley
>
