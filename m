Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794800799;
	b=J0Er2WWeYHGGTzWSkTcIXa53IO5VEYK4F8nJ1S1rt9Lr7ajzVAZVHqqbMtxQzxwcinda
	 P40vrm3bAzdnmoItjVrGFXbET1H3Ia3zHRbxKSsXzYID1PtdjKiCi6q5O9Vt8T1nvNf8i
	 AXW3tWDPBxWGwRsARcDRPpR+W706oTW9JT7YwNJfbJgFpClnMa2SK5cFDzo0cSrS3NtZO
	 kXlDRvoxReaDAlwOPH1+8y7WTlJ0PGfpmy+EStFrfud6wM0LBGg6aoPhaxX07Fqqg/zqM
	 K83OuYZ/0wEguRcxCfbsRhGAnZHUeNNh/N7uFy2jllIYFSEtllQpPFwnE6Zgv4mU5Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794800799;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=NAUBpZotW47o2arQ8nedb6I35c0CY0MGRTyMl/yh2Io=;
	b=OxFyHk0jr/C0WfrUjFw8e0gwjyc1rxnkeXyV1YcoPY4hlHWRNFuCmnTyblgzx3d6kiZj
	 fpnP+FqhTnBZkawTBfmzox1XYlbcmF7dP25lO2TL+TyfSZXsDWXJdaGsqXWVn+GJE85uN
	 DZuCZknIaQx6a5tZdhs+vTPtBH+6MFBvGZRkBAk4cASeV/J6XsiTzbXMoaCaBn4jOlHgI
	 Fg9tCUGX8eUJgW8K+sB3YuEMM8R5MEbh6rWJaIfrBJCw0+UcRkhqRnfrRrrCHmjpEBwgA
	 NXuK1HWS2Sq60PP7loUnAn+knw6OP1l0JuthoS6f5DU/DpAbJ+QxIQkT/LjLC7830kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWeL51CI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469D606A899;
	Mon, 16 Nov 2026 03:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWeL51CI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D471F000C4;
	Mon, 16 Nov 2026 03:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794800799;
	bh=NAUBpZotW47o2arQ8nedb6I35c0CY0MGRTyMl/yh2Io=;
	h=From:Subject:Date:To:Cc;
	b=QWeL51CI/pNtYWdhyAsw9sTmN2Sx5QX9eb7RlpYtCaUP6SAajcK6qsXnNO6muEfE4
	 zAgt8n5H5YWCfKUujjd8vm0ErkCx+r+UoCxrZJWHGdGGyhoT4glFUt7rzvKxtN5ISM
	 ngdhRvJyJRmnYjQ5RvEb7gKwpEOEKA5LLpfWnGOXtlXdBcM77xUnxAFpZt4+vwO4wF
	 srKiMW2ToWm3dlH7h/QdV4Szia9QqMfVFmLOiwt98z2dQLUObz1qJvPbgQiqTZ4vBo
	 DPGImvmNZhT3VZ1zyhKYdilwv7McppGAUrXN4tne8/9v89zue6mtmiSdqnCyQdyYLX
	 T0A9USDOhiLGQ==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v8 0/2] Add UFS Host driver support for SpacemiT K3 SoC
Date: Mon, 16 Nov 2026 03:46:20 +0000
Message-Id: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23RTW7DIBAF4KtErEs1DJifrHqPqgswkLipbAtsq
 1XkuxcnUpPKLJ8075sRXEkOqQuZHA9XksLS5W7oS9AvB9KebX8KtPMlEwSUIKGhoOmF0zlmmud
 xHNJEW+046CBYE5CU3phC7L5v5vvHPefZfYZ22qBt4tzlaUg/t6UL2+buvgKs+AujQJmVwnLrG
 Or4dgmpD1+vQzqRbcGCTwTWTlyKS0UDXFq0KJjeEfxBaJA1ghcCuIqOI9rWux0hHoQp/QohClH
 KFp03yvM90TwRrHpFs71FbLxikQEqvyPkE4GsRhSXcqGMktoiGrMj1B/BoP4jqhDOcQOgYjQ2/
 CPWdf0Fcwe16lcCAAA=
X-Change-ID: 20260605-08-k3-ufs-support-c8b308e415e2
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, 
 Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4524; i=dlan@kernel.org;
 h=from:subject:message-id; bh=xEdNTK8Ye3JW5fmjOuaC9e/3nAzJW+wIN/baC3WN+eM=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBq+nyQsi937bP7Jm9xsE8YmOfL5XY24XSPmuQIv
 1lGeZPxalOJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCavp8kBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+3hRg//VtSMiwu5qx6GWorVjVqsCeq4mvyHUg6BuwbuAkh7MuSd1nKOJYfrA
 21p8Pupu3Fo36x7nDTI8Gk12upBq42Cs3b919BATbp+VXeGhxG4NnVGE+Rl6aXF23hxJO2zlsUp
 +Ru/fypduUBKdFWcOZmUi8T6xzyz2j7moxH4/3s8em3le0V7AeTeICBvnkZ/DvRiAksC9re50Fk
 Ukrkgnjtyyu07yq3WX35W4El0qQLxyy7XLWW+iGLcptODJ4npIi/b5TVez5D/vpd1Yi1beZp7rX
 HcVYz872N2yd+RS5l4VHSycnmcidxVMAFMoBT+7f86kHpcVyab1jbB6579x98qSiJzEgvEvmyjN
 EoyFIoDeUcmvDfMzypWGKqIKWDN0wxle99HAFi0Ai2y6wjlwzW7FqG7Ub9AqaZxlpwI6P2eIcMv
 vmEiQGWBndttrn9sJ+PlJvJWJQCTCxfs6BQU4RnQJRvS2eg6hCTnKM/ya3WPmd9ApFLfqUz8yVX
 SW0DD4VJV8uXmLaxwxIWpFDf3GX0XYxCzQ2Zs/RH56bcF3ivpqDfuOIsUfieHk0jSsxPXu28T3z
 phyrM5siY7Kk9z2Vvec6aA7OvUW/EbohpR4rR6zsJz6Y040O3M+nLwc7NDY+7LU4ups4Uy8J5hK
 4bW/7xUiQgVuYF3Xs2yAzLUEwLXwBU=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

This series try to add UFS support for SpacemiT K3 SoC, the controller
components consists of System Bus Interface Unit, UFS Host Controller
Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
Management Entity (DME), Transport Layer, Network Layer, Data Link
Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
block diagram can be found in SpacemiT website, chapter 9.7.3 [1]

The DTS patch has been dropped in this series [2], and will send
in separate series once this patch accepted. For people who want to
test UFS driver, please grab the DT patch from version v5 [3].

Enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND,
This allows the device auto-bkops to be always enabled except
during suspend (both runtime and suspend), with this feature,
the BKOPS interrupt (log below) isn't reported anymore.

[  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1

Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
Link: https://lore.kernel.org/all/20260918-belligerent-succinct-kraken-7fa592@quoll/ [2]
Link: https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org/ [3]
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
Changes in v8:
- enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND
- rename to "ref_clk", see explanation in patch
- add delay between enable clk & deassert reset
- respect bRefClkGatingWaitTime, add wait delay
- drop comment of ufs_hba_spacemit_vops, which got CI complaint
- rebase to v7.4-rc1
- Link to v7: https://patch.msgid.link/20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org

Changes in v7:
- check err return value of ufs_spacemit_quirk_host_pa_saveconfigtime()
- Link to v6: https://patch.msgid.link/20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org

Changes in v6:
- drop unused macro and dev_req_params
- use global PX_xx macros
- fix axi clock name
- drop dts patch
- collect tags
- Link to v5: https://patch.msgid.link/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org

Changes in v5:
- adjust clock names
- add runtime power support
- collect tags
- Link to v4: https://patch.msgid.link/20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org

Changes in v4:
- fix clock and reset settings
- drop function which retrieve value of tx_lanes
- propagate return error of ufs_spacemit_dme_set()
- check return value ufs_spacemit_check_hibern8()
- drop call to ufshcd_vops_phy_initialization()
- handle compiling warning if CONFIG_OF not enabled
 add __maybe_unused to ufs_spacemit_of_match
- Link to v3: https://patch.msgid.link/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org

Changes in v3:
- collect tags
- fix dt-binding warning reported-by sashiko
- fix low freq in opp-2 table
- fix err checking in check_hibern8()
- propagate err code in link_startup_notify()
- update documents for event_notify()
- ufs clock driver is merged into v7.3-rc1, update cover letter
- Link to v2: https://patch.msgid.link/20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org

Changes in v2:
- fix missing interrupts property
- move ufs node to k3-com260.dtsi
- convert freq-table-hz to operating-points-v2
- rework reset_control, fix header and drop global variable
- drop dump_host_regs() debug interface
- converge and refactor dme_set() operations
- massive reduce of busy delay() loops
- drop vendor specific hce_enable_notify(), fallback to default
- drop unused member from struct ufs_spacemit_host
- add COMPILE_TEST support to Kconfig
- comment style fix
- Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org

---
Yixun Lan (2):
      scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
      scsi: ufs: spacemit: k3: Add UFS Host Controller driver

 .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
 drivers/ufs/host/Kconfig                           |  12 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-spacemit.c                    | 655 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  77 +++
 5 files changed, 801 insertions(+)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

