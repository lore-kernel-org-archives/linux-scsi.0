From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v4 6/7] Revert "scsi: ufs: disable vccq if it's not needed
 by UFS device"
Date: Sat, 9 Feb 2019 09:07:41 +0000
Message-ID: <SN6PR04MB49252A044910AC48672F1043FC6A0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <09ce9c20-c47b-f936-a8a9-6c8ec8f0f867@free.fr>
 <817ff724-2a30-99fb-8a92-c77797651bde@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <817ff724-2a30-99fb-8a92-c77797651bde@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Rob Herring <robh+dt@kernel.org>, Kishon Vijay Abraham <kishon@ti.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Martin Petersen <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,
>=20
> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
>=20
> Calling ufshcd_set_vccq_rail_unused() breaks UFS init on two boards.
> I would say that vccq is *not* not needed.
>=20
> Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
Those  tags got switched off.

I still think that If you are reverting the quirk implementation,
you should remove the quirk listing as well.

Also, as the v3 discussion held on several threads,
and new people might be joining in,=20
maybe you could reply to this patch with a couple of sentences summing-up
the various theories that this bring-up raised.

Thanks,
Avri=20
