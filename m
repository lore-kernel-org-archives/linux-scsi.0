From: Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom
Date: Mon, 14 Jan 2019 09:07:57 -0800
Message-ID: <CAD=FV=ULU0JA1LAruHh2KyXOc0dzuQNZTjV0PAEX2J_Ra2=ZRw@mail.gmail.com>
References: <20190111233159.218342-1-evgreen@chromium.org> <yq1imyuv95c.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1imyuv95c.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, masneyb@onstation.org
Cc: Evan Green <evgreen@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Vinayak Holikatti <vinholikatti@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

On Fri, Jan 11, 2019 at 7:37 PM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Evan,
>
> > CONFIG_SCSI_UFS_QCOM selects CONFIG_PHY_QCOM_UFS, assuming that
> > this was the only possible PHY driver Qualcomm's UFS controller
> > would use. But in SDM845, the UFS driver is bundled into phy-qcom-qmp,
> > and phy-qcom-ufs is unused.
> >
> > Remove the select, since for SDM845 it adds useless drivers to the
> > build.
>
> Applied to 5.1/scsi-queue.

Should this be accompanied by a change to arch/arm64/configs/defconfig
that sets 'CONFIG_PHY_QCOM_UFS=m'?  I don't personally have any
non-SDM845 devices to test on, but I'm sorta assuming they will all
break without the defconfig update?

Added a few more people (and linux-arm-msm list) to this thread in
case this matters to anyone.

-Doug
