Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827008;
	b=e3EGgYmoWrs4jiEOvZh4+wo40eqTW1HIYaJw3OZxSA9zhvZy2WIqQQG7nhslZv/0NGbF
	 mE6uskpe5R4v+OLEE2Q1te+GXCTD0kcIqduv6hoaYD5qqBLYxNY1dJmVq1/+EtZSf5V8H
	 tC0rB1qCiF+DDyt8C7MsYzh5oK8yZAsPTWP4ch0ldSZ8cMi3n5RQ/sWnIl9L587HiOEd0
	 Y2s68uNEbgoazrl4ND1Y0kaZ+FyVx+exffElaCdt848DWQOpU9t0CpyACU6kwD6E2iOPx
	 xfnHcOLMOwLoGDl+7cpuPhNH2advGg8j4QKNFqYHRZyLZdfqs0e9F7kw3upTz62d3wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827008;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=vjndxlGs8agolDhu4c30Y/rDIfGEQD4LOMd0Ft+WwAk=;
	b=Qqrgl0mkVf9ZVZsi89IgWRYR9mrNcSUrhm4akY1MzBSwnHulW3zDpyMbhO8B1SuBzutX
	 GnGTMo32TJXgv/biDPIfe/7Of9J0HL9A4bqjdu2246h+aNEWzesqwFsoZ1JPc0KS3LJbB
	 TbB8Sj8wyWS4C7ZLjSdYQplqsuqI+OqhdNQLmYvWc1cgVTbjjYKMywiQeZE1Do/Ids8Gi
	 nCaVj76hl0LAzLs8O2GiG4zQuIgQoP+dNMu8I9zr+uJCGKUf9JFVtp2xBZ/ucTXeGchRN
	 RuV0FwbgKvJuB+ufjcgD3Kc4lHEN2pxE94E+sjHtVzyhB20tt3A2st4DOmvinIGPOgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GR0DhEG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9C2606A31C;
	Sat, 28 Nov 2026 00:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GR0DhEG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539001F00897;
	Sat, 28 Nov 2026 00:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795827008;
	bh=vjndxlGs8agolDhu4c30Y/rDIfGEQD4LOMd0Ft+WwAk=;
	h=From:Subject:Date:To:Cc;
	b=GR0DhEG9hg0CyA+l0PyxYEcASdvJD6sWhSFTvu1FdtaFLbw75MxSQy7ZGTXrsQ4Ze
	 29S3kw19g9WZ26pJ7PWvzaBEjjoNRJEOm2M5G1+H+Jutw3uuw4TQ8C6XVMq0agKf4H
	 WN27F2Rx9eA6sdXdBFIjsQwfnLTrRYrjQ51Dkvt+ucK8MsVtfLij5PUjTkKBczDxpD
	 vzbFCa4ASPOVd4vKzLPIRMr/NKRGkGyLtwggdQIw0jJVvWwkTFPTjkQlypBCvcRZbA
	 hkKNre0mvBY31jzaTSC5pgB053y4dogiAx8tUBqtdNqMMN6gGP4E0LW8BmamQbl56P
	 /1XzStpJy9hsQ==
From: Yixun Lan <dlan@kernel.org>
Subject: [PATCH v9 0/2] Add UFS Host driver support for SpacemiT K3 SoC
Date: Sat, 28 Nov 2026 00:49:50 +0000
Message-Id: <20261128-08-k3-ufs-support-v9-0-d27deb096d1e@kernel.org>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23RzW7DIAwH8FepOI/JmO+e9h7TDhCgzTolFbTRp
 irvPtJKa6ZwtOT/z8bcSIm5j4XsdzeS49SXfhxqYV92pDu64RBpH2pNEFCBAknB0BOn11RouZ7
 PY77QzngOJgomI5KaO+eY+u+7+f7xqMvVf8buskBLx7EvlzH/3IdObOl7+Bqw4U+MAmVOCcedZ
 2jS2ynmIX69jvlAlgETrghsrThVlwoJXDl0KJjZEPxJGFAtglcCuE6eI7ou+A0hnoSt+QYhKlH
 DDn2wOvAtIVcEa24hl1skGTRLDFCHDaFWBLIWUV3KhbZaGYdo7YbQfwSD9o/oSnjPLYBOybq4I
 cyTYO2H1APRyD1KZTWGIP4R8zz/Ah+SvN+aAgAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4760; i=dlan@kernel.org;
 h=from:subject:message-id; bh=ijdGu8Pq+mlJCyptmqzWKnq4/EZfSxirNaoZEs5mmoU=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBrCiUxXB8uGzZjJ8KijOFXnf8hfPcxZ6WUlDIdb
 EBdZru+wDuJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCawolMRsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+0roA//ap7dPnk/FX3i4aIjXjh1JFemAzo0qpJYzXhyAUC58V+ntTP+yacq8
 dJrJxo8c2ZiLV7OEYzyrL8K3OM2W8Gz+z1n8NPRBDkRtkb9LwOarKQZtwkqChqbGLUE5SAMcUpT
 fUiy/Ii38fr3SgSaAYxvWW1yqMpnr7Q9ePojmDAe7aQvgLub3YeXGlDIC3nWmVap9FpxRROtHcR
 ffWqZcnUzueohPkf5R67jRNfyhTxs12IAEMu7XBjkIKYwGpmmJNZT93EfjbPSTxBV2sptv9dfUZ
 OUF/xx7MlssxY38ePUWaz4AjQffn6dZWUxDoCJQZ464DXCF3+9iNbBV/y4Jc5XTVYQNd1Lm6oS9
 jCZMMtDHyMdHkQlU26sRsHc7uuAL9dWDU4U4iFyjT+h4144s6JM6Wt9E7TnjnoinjZk3tF+jxpz
 pI0QLpuI9qDiRACFCv/H2Awwd0o+zH40Vpjm2sYTipSXw4wBL/0UQ5MqwRpzxm7fZkQi8Ov/IV9
 /XJ4TprTRAFuW6/Gsqx2nzbkZ0hIQu3Q6aRaJc/NMG9f5YBx2I7BLF5PTmKbDXO6T25HzbtOfD5
 UK4U6+qH5Hyl2tVjCuscMcmTQOndIXRQawYeV6ImUlrwbmku5jvXXs/nSAZiAU+yV8Zxi1yrmNV
 0nppsrF57EB12nF8WWTZnO/9+eTjSk=
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
Changes in v9:
- return check of ufs_spacemit_dme_set()
- drop spacemit_ufs_set_dev_cap()
- log ->saved_err 
- sort macro definition
- Link to v8: https://patch.msgid.link/20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org

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
 drivers/ufs/host/ufs-spacemit.c                    | 619 +++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h                    |  81 +++
 5 files changed, 769 insertions(+)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260605-08-k3-ufs-support-c8b308e415e2

Best regards,
--  
Yixun Lan <dlan@kernel.org>

