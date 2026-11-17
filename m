Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794885440;
	b=pBnbpmsu/ibOVpynmyX7iP956MrMmSIUon1RUlXN/wLYUKjiTl77btGS5tTtWcpfBNIs
	 ywqTzUswJNSsXttFlXENbVTYwtvWwM4n2+uVYXCQjIIoAaI0CtheigajrLnhDYdnKTqvm
	 teMA1YfbaL52CwOR49V9OZMm/PQKkkIrZp3cCLm8U3HzHOAJeVFHLt0jwJuXb9Bf05Hct
	 PU+2oaEE0KCa9fubu3kCRdtEU1v3jME3sFm20VSSnApw/3w98AJUFpcvFO+7PdAy5NgZ6
	 vLS31tirZ19sQH8r0cm+8bRpOSoAAGhr64NqQCwDr6tNCCJjamqqJ+HppEjPSqr1gjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794885440;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=u7WxQThHDrtVVlvttx5gutd4hdHvIUx8LTX+PTgMIwA=;
	b=FB/G0gi5RHn0WTkZa5LbnYr6uUceLZ4GKY8jGHdIH6AgUBQpe3gHWf0SEohZs9BmWevQ
	 qkFNb8RZ6T9LE8fnxejXCm1l6XgOLm26y4hPkT9gaaCP8e/Qp8nEM8Mos9NPia/Q/hh/J
	 SiNALGuvgEFytJyLk3PRkE4f3XKg8VId9j7OR1i9R7kPIH1a2SoDg7yCysaf05jy5bbX8
	 /K6zCnNB+SLGiqojKawBeNHll4GV8JkEtyQPPWL3H9LwJdL/oQDt4GY1dSXQaa8cabLWH
	 oGlNxVpRGu1516G3KS1LhI7pQAzvYtyRJTk9DqOE6tFGUeuJl7d5Ksy5Mw0beJlZNFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fG6ix43A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D81606A31C;
	Tue, 17 Nov 2026 03:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fG6ix43A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEDC1F000C5;
	Tue, 17 Nov 2026 03:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794885439;
	bh=u7WxQThHDrtVVlvttx5gutd4hdHvIUx8LTX+PTgMIwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fG6ix43Aj+ltOOd7+9gPvpl7gEibFLnYb3d7SYQlKvsNJTJnu8rSifRdfs3120SdL
	 lJGbozuhewlEmMezq/443vqffmaZ2KZnnumT59+wtqAp++6+3X8ynV3OvK5LBqVbwJ
	 ouRBE3i6q6XQ6vAK9j9wAZsX8AHAdA+VZTJ4FUg2/j6wRXayqF8jCpVMiS8dMGnRE1
	 idRsekwB1FegJr0KYkF8Hvnss2h8avXeEkxpTU9gU1mbJBsS2OwWiRAR0qfR1kPrPc
	 lkoO5GPqmjbzDhNJ3VkkWmQvZQY4BeSx/V+gvWuQvkaRsxu8kiWAx9r1v98vNCcHs1
	 KJaSiVlzLvcaQ==
Date: Tue, 17 Nov 2026 03:17:17 +0000
From: Yixun Lan <dlan@kernel.org>
To: E Shattow <e@freeshell.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jennifer Berringer <jberring@redhat.com>,
	Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-riscv@lists.infradead.org,
	spacemit@lists.linux.dev, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v8 0/2] Add UFS Host driver support for SpacemiT K3 SoC
Message-ID: <20261117031717-GKG100523@kernel.org>
References: <20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org>
 <8462a0d9-e9b7-467d-b2e1-7870c78e2691@freeshell.de>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8462a0d9-e9b7-467d-b2e1-7870c78e2691@freeshell.de>

Hi E Shattow,
Thanks for testing

On 17:15 Mon 16 Nov     , E Shattow wrote:
> Hi Yixun,
> 
> On 11/15/26 19:46, Yixun Lan wrote:
> > This series try to add UFS support for SpacemiT K3 SoC, the controller
> > components consists of System Bus Interface Unit, UFS Host Controller
> > Interface, UFS Transport Protocol Layer, UFS Host Registers, Device
> > Management Entity (DME), Transport Layer, Network Layer, Data Link
> > Layer, PHY Adapter Layer, and M-PHY Interface. A more detail functional
> > block diagram can be found in SpacemiT website, chapter 9.7.3 [1]
> > 
> > The DTS patch has been dropped in this series [2], and will send
> > in separate series once this patch accepted. For people who want to
> > test UFS driver, please grab the DT patch from version v5 [3].
> > 
> > Enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND,
> > This allows the device auto-bkops to be always enabled except
> > during suspend (both runtime and suspend), with this feature,
> > the BKOPS interrupt (log below) isn't reported anymore.
> > 
> > [  806.710763] ufshcd-spacemit c0e00000.ufshc: ufshcd_bkops_exception_event_handler: device raised urgent BKOPS exception for bkops status 1
> > 
> > Link: https://spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/09_memory_storage.md&lang=en [1]
> > Link: https://lore.kernel.org/all/20260918-belligerent-succinct-kraken-7fa592@quoll/ [2]
> > Link: https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-3-1f5d71f1027d@kernel.org/ [3]
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> > Changes in v8:
> > - enable UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND
> > - rename to "ref_clk", see explanation in patch
> > - add delay between enable clk & deassert reset
> > - respect bRefClkGatingWaitTime, add wait delay
> > - drop comment of ufs_hba_spacemit_vops, which got CI complaint
> > - rebase to v7.4-rc1
> > - Link to v7: https://patch.msgid.link/20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org
> > 
> > Changes in v7:
> > - check err return value of ufs_spacemit_quirk_host_pa_saveconfigtime()
> > - Link to v6: https://patch.msgid.link/20260921-08-k3-ufs-support-v6-0-3479768a2299@kernel.org
> > 
> > Changes in v6:
> > - drop unused macro and dev_req_params
> > - use global PX_xx macros
> > - fix axi clock name
> > - drop dts patch
> > - collect tags
> > - Link to v5: https://patch.msgid.link/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org
> > 
> > Changes in v5:
> > - adjust clock names
> > - add runtime power support
> > - collect tags
> > - Link to v4: https://patch.msgid.link/20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org
> > 
> > Changes in v4:
> > - fix clock and reset settings
> > - drop function which retrieve value of tx_lanes
> > - propagate return error of ufs_spacemit_dme_set()
> > - check return value ufs_spacemit_check_hibern8()
> > - drop call to ufshcd_vops_phy_initialization()
> > - handle compiling warning if CONFIG_OF not enabled
> >  add __maybe_unused to ufs_spacemit_of_match
> > - Link to v3: https://patch.msgid.link/20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org
> > 
> > Changes in v3:
> > - collect tags
> > - fix dt-binding warning reported-by sashiko
> > - fix low freq in opp-2 table
> > - fix err checking in check_hibern8()
> > - propagate err code in link_startup_notify()
> > - update documents for event_notify()
> > - ufs clock driver is merged into v7.3-rc1, update cover letter
> > - Link to v2: https://patch.msgid.link/20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org
> > 
> > Changes in v2:
> > - fix missing interrupts property
> > - move ufs node to k3-com260.dtsi
> > - convert freq-table-hz to operating-points-v2
> > - rework reset_control, fix header and drop global variable
> > - drop dump_host_regs() debug interface
> > - converge and refactor dme_set() operations
> > - massive reduce of busy delay() loops
> > - drop vendor specific hce_enable_notify(), fallback to default
> > - drop unused member from struct ufs_spacemit_host
> > - add COMPILE_TEST support to Kconfig
> > - comment style fix
> > - Link to v1: https://patch.msgid.link/20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org
> > 
> > ---
> > Yixun Lan (2):
> >       scsi: ufs: spacemit: dt-bindings: Add UFS controller for K3 SoC
> >       scsi: ufs: spacemit: k3: Add UFS Host Controller driver
> > 
> >  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml |  56 ++
> >  drivers/ufs/host/Kconfig                           |  12 +
> >  drivers/ufs/host/Makefile                          |   1 +
> >  drivers/ufs/host/ufs-spacemit.c                    | 655 +++++++++++++++++++++
> >  drivers/ufs/host/ufs-spacemit.h                    |  77 +++
> >  5 files changed, 801 insertions(+)
> > ---
> > base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> > change-id: 20260605-08-k3-ufs-support-c8b308e415e2
> > 
> > Best regards,
> > --  
> > Yixun Lan <dlan@kernel.org>
> > 
> > 
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
> 
> Tested v7 and v8 successfully on Sipeed K3 Pico-ITX (32GiB DRAM / 128GiB
> UFS model). Build and test methodology:
> 
> ### build chimera debian-installer with patched mainline kernel
> ### assume fresh Debian testing "forky" build environment
> 
> apt update
> apt install -y b4 bc bison ca-certificates cpio \
>  crossbuild-essential-riscv64 curl debhelper fakeroot flex kmod \
>  libdw-dev libssl-dev libssl-dev:riscv64 linux-config-7.2:riscv64 \
>  python3 rsync
> 
> curl -L \
>  https://git.kernel.org/torvalds/t/linux-7.4-rc3.tar.gz \
>  | tar xz
> 
> pushd linux-7.4-rc3
> b4 am -v1 -o- \
>  https://lore.kernel.org/all/20261115195112.32120-1-e@freeshell.de/ \
>  | patch -p1
> b4 am -v5 -P3 -o- \
>  https://lore.kernel.org/all/20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org/ \
>  | patch -p1
Did you rename clock name from "ref" to "ref_clk"? see my comment in patch 1

> b4 am -v8 -P1,2 -o- \
>  https://lore.kernel.org/linux-riscv/20261116-08-k3-ufs-support-v8-0-e3b256972dd4@kernel.org/ \
>  | patch -p1
[...]
> 
> Workload for testing is to repeat the above build steps on-device from
> UFS-backed root filesystem. In v7 there would be the occasional BKOPS
> warnings, and v8 here now no such BKOPS warnings.
> 
> I do notice some UFS-related warnings and errors in dmesg:
> 
> journalctl --dmesg | grep ufshcd
> ufshcd-spacemit c0e00000.ufshc: freq-table-hz property not specified
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vdd-hba-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vcc-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vccq-supply regulator, assuming enabled
> ufshcd-spacemit c0e00000.ufshc: ufshcd_populate_vreg: Unable to find
> vccq2-supply regulator, assuming enabled
> scsi host0: ufshcd
> ufshcd-spacemit c0e00000.ufshc: ufshcd_scsi_add_wlus: BOOT WLUN not found

Let's ignore the warning message for now, those shouldn't cause problem

> ufshcd-spacemit c0e00000.ufshc: DL error event, INT errors:0x4,
> DL_ERR:0x80000020
> 
Seems relate to Data link error, I will see if I can replicate this .. 

-- 
Yixun Lan (dlan)
