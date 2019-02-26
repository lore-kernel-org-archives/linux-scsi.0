From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v5 0/2] Clean up UFSHC driver
Date: Tue, 26 Feb 2019 08:57:30 +0000
Message-ID: <20190226085730.GK4118@dell>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
 <60e5da74-da0d-4ba7-6d29-2ca6008b6ceb@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60e5da74-da0d-4ba7-6d29-2ca6008b6ceb@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 23 Feb 2019, Marc Gonzalez wrote:

> Martin,
> 
> Could you send this series to -next so that it gets some exposure
> and testing during the 5.1 RC cycle?

Replying for the purpose of providing some gravitas to this set.

These patches are required to support some exciting consumer hardware
which has been recently released [0][1][2][3][4].  If they do not
find their way into Mainline very soon, it would mean that supporting
these devices in the most popular Linux distos will be difficult to
impossible.

Please consider them for the v5.1 merge window which opens in a week.

[0] https://joindiaspora.com/posts/4714199011120137995e0218b7b935a5
[1] https://liliputing.com/2019/02/now-you-can-run-linux-on-some-arm-laptops-designed-for-windows-10-on-arm.html
[2] https://www.phoronix.com/scan.php?page=news_item&px=Linux-On-The-Win-Arm-Laptops
[3] https://fossbytes.com/linux-on-windows-10-arm-laptops-project/
[4] https://www.techrepublic.com/article/open-source-project-aims-to-make-ubuntu-usable-on-arm-powered-windows-laptops/

> On 11/02/2019 14:31, Marc Gonzalez wrote:
> 
> > Casting a wide net to get as many eyeballs on the subject as possible.
> > 
> > I'm splitting this mini series off from the main "UFS on APQ8098/MSM8998"
> > as it's 1) ufs/scsi specific 2) controversial (to my surprise)
> > 
> > Please send all your Reviewed-by: tags if you agree with the patch,
> > and/or voice your concerns ASAP.
> > 
> > This series removes the "disable-VCCQ-power-rail-for-some-Flash-chips" quirk,
> > and cleans up after the dust settles.
> > 
> > Marc Gonzalez (2):
> >   scsi: ufs: Do not disable vccq in UFSHC driver
> >   scsi: ufs: Remove unused device quirks
> > 
> >  drivers/scsi/ufs/ufs.h        |  1 -
> >  drivers/scsi/ufs/ufs_quirks.h | 29 ----------------
> >  drivers/scsi/ufs/ufshcd.c     | 63 +++--------------------------------
> >  3 files changed, 4 insertions(+), 89 deletions(-)

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
