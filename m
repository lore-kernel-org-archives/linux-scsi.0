From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v5 0/2] Clean up UFSHC driver
Date: Wed, 13 Feb 2019 15:55:54 +0530
Message-ID: <7ce5a14a-56a7-22bb-b16e-fc898c0ea6e8@samsung.com>
References: <CGME20190211133457epcas3p2dc95fa2c93c3cf884a376f0282be8b8a@epcas3p2.samsung.com>
        <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Hi Marc,

On 11/02/19 7:01 PM, Marc Gonzalez wrote:
> Casting a wide net to get as many eyeballs on the subject as possible.
> 
> I'm splitting this mini series off from the main "UFS on APQ8098/MSM8998"
> as it's 1) ufs/scsi specific 2) controversial (to my surprise)
> 
> Please send all your Reviewed-by: tags if you agree with the patch,
> and/or voice your concerns ASAP.
> 
> This series removes the "disable-VCCQ-power-rail-for-some-Flash-chips" quirk,
> and cleans up after the dust settles.
> 
> Marc Gonzalez (2):
>    scsi: ufs: Do not disable vccq in UFSHC driver
>    scsi: ufs: Remove unused device quirks
> 
>   drivers/scsi/ufs/ufs.h        |  1 -
>   drivers/scsi/ufs/ufs_quirks.h | 29 ----------------
>   drivers/scsi/ufs/ufshcd.c     | 63 +++--------------------------------
>   3 files changed, 4 insertions(+), 89 deletions(-)
> 
For this series
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
As no other platform has claimed issues with this we can land this.
Others let us know if your opinion differs here.

Acked-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks!
