From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom
Date: Mon, 14 Jan 2019 10:41:43 -0800
Message-ID: <CAE=gft7OhomkDT7pMBbRRgKK89CVhmigbebgqiDEqTZtjeXhcg@mail.gmail.com>
References: <20190111233159.218342-1-evgreen@chromium.org> <yq1imyuv95c.fsf@oracle.com>
 <CAD=FV=ULU0JA1LAruHh2KyXOc0dzuQNZTjV0PAEX2J_Ra2=ZRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD=FV=ULU0JA1LAruHh2KyXOc0dzuQNZTjV0PAEX2J_Ra2=ZRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Anderson <dianders@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, masneyb@onstation.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 14, 2019 at 9:08 AM Doug Anderson <dianders@chromium.org> wrote:
>
> Hi,
>
> On Fri, Jan 11, 2019 at 7:37 PM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> >
> > Evan,
> >
> > > CONFIG_SCSI_UFS_QCOM selects CONFIG_PHY_QCOM_UFS, assuming that
> > > this was the only possible PHY driver Qualcomm's UFS controller
> > > would use. But in SDM845, the UFS driver is bundled into phy-qcom-qmp,
> > > and phy-qcom-ufs is unused.
> > >
> > > Remove the select, since for SDM845 it adds useless drivers to the
> > > build.
> >
> > Applied to 5.1/scsi-queue.
>
> Should this be accompanied by a change to arch/arm64/configs/defconfig
> that sets 'CONFIG_PHY_QCOM_UFS=m'?  I don't personally have any
> non-SDM845 devices to test on, but I'm sorta assuming they will all
> break without the defconfig update?

Right, thanks for pointing that out. I'll send out another patch to
tweak the defconfig.
-Evan
