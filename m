From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 0/3] (Qualcomm) UFS device reset support
Date: Tue, 4 Jun 2019 15:00:27 -0700
Message-ID: <CANcMJZBmgWMZu7Y53Lnx_x3L2UpCmEbFRHVW0SFCXfW=Yw9uYg@mail.gmail.com>
References: <20190604072001.9288-1-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604072001.9288-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 4, 2019 at 12:22 AM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> This series exposes the ufs_reset line as a gpio, adds support for ufshcd to
> acquire and toggle this and then adds this to SDM845 MTP.
>
> Bjorn Andersson (3):
>   pinctrl: qcom: sdm845: Expose ufs_reset as gpio
>   scsi: ufs: Allow resetting the UFS device
>   arm64: dts: qcom: sdm845-mtp: Specify UFS device-reset GPIO

Adding similar change as in sdm845-mtp to the not yet upstream
blueline dts, I validated this allows my micron UFS pixel3 to boot.

Tested-by: John Stultz <john.stultz@linaro.org>

thanks
-john
