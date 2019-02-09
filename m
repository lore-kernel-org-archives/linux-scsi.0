From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: Re: [PATCH v4 6/7] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Sat, 9 Feb 2019 10:54:09 +0100
Message-ID: <b09a33a2-65fd-55b0-f3c4-1b071d086a22@free.fr>
References: <09ce9c20-c47b-f936-a8a9-6c8ec8f0f867@free.fr>
 <817ff724-2a30-99fb-8a92-c77797651bde@free.fr>
 <SN6PR04MB49252A044910AC48672F1043FC6A0@SN6PR04MB4925.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <SN6PR04MB49252A044910AC48672F1043FC6A0@SN6PR04MB4925.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <Avri.Altman@wdc.com>, MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Rob Herring <robh+dt@kernel.org>, Kishon Vijay Abraham <kishon@ti.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Martin Petersen <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/02/2019 10:07, Avri Altman wrote:

> On 08/02/2019 23:20, Marc Gonzalez wrote:
>
>> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
>>
>> Calling ufshcd_set_vccq_rail_unused() breaks UFS init on two boards.
>> I would say that vccq is *not* not needed.
>>
>> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
>> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
>
> Those tags got switched off.

What do you mean?

> I still think that If you are reverting the quirk implementation,
> you should remove the quirk listing as well.

You're right, of course. I just thought it could wait until
after this series was accepted, but I can fold it in v5, as
a follow-up patch.

> Also, as the v3 discussion held on several threads,
> and new people might be joining in, 
> maybe you could reply to this patch with a couple of sentences summing-up
> the various theories that this bring-up raised.

Will do in v5, either in the commit message, or in the
sub-text that is not committed.

Regards.
