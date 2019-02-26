From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v5 0/3] UFS on APQ8098/MSM8998t
Date: Tue, 26 Feb 2019 08:22:51 +0000
Message-ID: <20190226082251.GI4118@dell>
References: <43768d77-80b7-9cdc-b6e0-08ec4a026c21@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43768d77-80b7-9cdc-b6e0-08ec4a026c21@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: MSM <linux-arm-msm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Feb 2019, Marc Gonzalez wrote:

> Hello,
> 
> This series adds support for the UFS host controller on APQ8098/MSM8998-based boards.
> 
> This should be the final rev ;-)
> 
> Differences between v4 and v5:
> - Drop patches that have already been accepted or spun off
> 
> Differences between v3 and v4:
> - Rebase on top of -next
> - Pick up Douglas Anderson's UFSHC doc fix
> - Document 8998 UFSHC binding
> - Improve UFS PHY binding doc
> - Put the UFS DT patch at the end of the series
> 
> Difference between v2 and v3:
> - Add qcom,msm8998-qmp-ufs-phy compat string and match it in the PHY driver
> - Drop vdd-hba-fixed-regulator
> - Write the reg addresses with full 32-bit width
> - Set regulator-allow-set-load only on the 3 rails used by UFS.
> - Revert the patch introducing ufshcd_set_vccq_rail_unused
> 
> Difference between v1 and v2:
> - New patch to add 'regulator-allow-set-load' prop to all vreg nodes
> - Rename rpmcc node to 'clock-controller' + Add Review tags
> - Drop UFS pinctrl gymnastics (not required, probably left enabled in bootloader)
> - Delete GCC_UFS_ICE_CORE_CLK (ICE not used upstream, I think)
> - Fix sizes of ufsphy register areas based on Jeffrey's feedback
> - Hack ufshcd_set_vccq_rail_unused into a NOP to work around lock up + reboot
> 
> 
> Marc Gonzalez (3):
>   dt-bindings: ufs: Add msm8998 compatible string
>   arm64: dts: qcom: msm8998: Allow UFSHC driver to set-load
>   arm64: dts: qcom: msm8998: Add UFS nodes
> 
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  1 +
>  arch/arm64/boot/dts/qcom/msm8998-mtp.dtsi     | 22 +++++++
>  arch/arm64/boot/dts/qcom/msm8998.dtsi         | 65 +++++++++++++++++++
>  3 files changed, 88 insertions(+)

I assume these are the same patches we've been using in our tree.

If so:

  Tested-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
