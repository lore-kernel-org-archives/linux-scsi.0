From: Evan Green <evgreen@chromium.org>
Subject: [PATCH] arm64: defconfig: Add Qualcomm UFS PHY
Date: Mon, 14 Jan 2019 11:01:12 -0800
Message-ID: <20190114190112.167922-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Will Deacon <will.deacon@arm.com>
Cc: Douglas Anderson <dianders@chromium.org>, linux-scsi@vger.kernel.org, Evan Green <evgreen@chromium.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Enric Balletbo i Serra <enric.balletbo@collabora.com>, Heiko Stuebner <heiko@sntech.de>, Marc Gonzalez <marc.w.gonzalez@free.fr>, linux-kernel@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>, Andy Gross <andy.gross@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org, Simon Horman <horms+renesas@verge.net.au>
List-Id: linux-scsi@vger.kernel.org

With commit 326a859b2814 ("scsi: ufs: Remove select of phy-qcom-ufs from
ufs-qcom"), the Qualcomm UFS controller no longer selects the Qualcomm
UFS phy (since it's not a given that PHY will be the one present).

Add that PHY into the defconfig since it's no longer being selected, and
Qualcomm platforms except for SDM845 need it.

Fixes: 326a859b2814 ("scsi: ufs: Remove select of phy-qcom-ufs from ufs-qcom")
Signed-off-by: Evan Green <evgreen@chromium.org>
---
I unfortunately don't have a non-SDM845 device to test this on. I'm hoping
it Just Works, or someone might be willing to give it a try.

Also, Martin, I'm not sure if your git commit IDs are stable, or whether or
not I should put the Fixes: in there. If they're not, this could be reordered
with the other commit and then there wouldn't need to be a Fixes. Let me know.

 arch/arm64/configs/defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 0478ef9e4b78e..d43644ca75997 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -694,6 +694,8 @@ CONFIG_PHY_HISTB_COMBPHY=y
 CONFIG_PHY_HISI_INNO_USB2=y
 CONFIG_PHY_MVEBU_CP110_COMPHY=y
 CONFIG_PHY_QCOM_QMP=m
+CONFIG_PHY_QCOM_UFS=m
+CONFIG_PHY_QCOM_UFS_14NM=m
 CONFIG_PHY_QCOM_USB_HS=y
 CONFIG_PHY_RCAR_GEN3_PCIE=y
 CONFIG_PHY_RCAR_GEN3_USB2=y
-- 
2.18.1
