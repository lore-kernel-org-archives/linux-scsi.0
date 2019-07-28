From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Allow resetting the UFS device
Date: Mon, 29 Jul 2019 00:09:20 +0200
Message-ID: <CACRpkdbSrGq7ma2ywyQ89N8PKQWLVUiz8NqE4iGyctyENcBKSQ@mail.gmail.com>
References: <20190606010249.3538-1-bjorn.andersson@linaro.org> <20190606010249.3538-3-bjorn.andersson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606010249.3538-3-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andy Gross <agross@kernel.org>, Evan Green <evgreen@chromium.org>, MSM <linux-arm-msm@vger.kernel.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 6, 2019 at 3:02 AM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:

> Acquire the device-reset GPIO and toggle this to reset the UFS device
> during initialization and host reset.
>
> Based on downstream support implemented by Subhash Jadavani
> <subhashj@codeaurora.org>.
>
> Tested-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

I agree with Rob that just "reset-gpios" looks better.
Otherwise:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
