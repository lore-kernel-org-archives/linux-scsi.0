Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792851670;
	b=Vo2+moQJwMI/VGYfNP3LpE48zr0200WnnCwwMQveHEqrjPlLTGivXqulkIZLUettSbyT
	 9yfrUBYYlYVV9OBzmm0jpmijJal871DBjkR8EvCUXctyZ7HLj5w8o8NfcetxcdpXtKUUl
	 2Qw863ISdTbrkTqb87QIv5l30vvd0zBIqvC9gLyQnxkeAc67sNDoYMEcWoRkh4qI41pP3
	 sCHVaTDlZ+K8ddPhUIJd8hvi7lzOXKLy4a7jcchylJKDoCGLyfzWgZrIzL2vuMFtcHc6l
	 j8z1ijN2p2sFjjzLoSznFzCq1DWsPq2nV9kT0s9ZAyoMB5QtC0xqhu9JVkAp0xF7ZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792851670;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=E4v/Pwg/hwmgS8S2uHoRyjMThXPxdp/Fot4x4veOR5s=;
	b=mWvOjeeU5c289CoBvSEIINuHRaNrwnKIpA8yx4gWoUJEKKcYF7EFx+z2R2f3TeJ0KCC/
	 gjSzBbMb10LCUqdgUyK+/7EAJ0eHqOZOwW2XpPzWtR+lJYMLZ7PtEIQDCbjPMCvOt9iX6
	 w8SJ+sTdXWdQIrj8ryih1Jt3OXJXhekNNsR6+e+N9RNWfmVCKtdeSTubC/yYWiw8AS37P
	 e+1QfxOEWTRDIko1Uqy6qnVd+O1ljdR215g9GVx1+oudk+ZaTs3sd+ClvxRtfSi1zN+El
	 rvfKEbqKXwqrLgIC+HshbotC5zuxp4eoYJ+cqeiYeTHSfSnsshnp6r1qLgHfgmvmz5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=B9Wslm6Q;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8736D606A31A;
	Sat, 24 Oct 2026 14:21:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8736D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=B9Wslm6Q
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jBhrh4VpTzlfvps;
	Sat, 24 Oct 2026 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792851653; x=1795443654; bh=E4v/Pwg/hwmgS8S2uHoRyjMT
	hXPxdp/Fot4x4veOR5s=; b=B9Wslm6Q5DW5Kwz6QLoGhUqEouux7juoGoag02X+
	URaO018ZstkNx/sMI/T17maDecVR7Nb5mnq1QL2SssD5KpaYXQTMFbMBDoUWY90O
	Pvco0uNXEP0qjt9GUlOQNglnzM2INdjz82o2JmbeFmg6PqNehT1eMasCxS5OJanX
	nME5+AcVegdZ7Xd0lHOYSK/YODvSGIwFCAxjVowQB92xHg+2KNBwBYfvEkojw7mO
	XxNd4nkdZrYBoRpIlssHnCUeqDGcyj7DED+9EYmuf2BQ2E64wh+9WDIRQrAC0UDU
	WwQhkbh1D1zDVFg0hHg1JYSecteKeWeuKNvtCMLLjfZQzg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HP2YyEJ6iqS8; Sat, 24 Oct 2026 14:20:53 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jBhrM3ZfTzlfvpN;
	Sat, 24 Oct 2026 14:20:51 +0000 (UTC)
Message-ID: <991fd1f4-b054-42ba-a157-cc9d89dc594b@acm.org>
Date: Sat, 24 Oct 2026 07:20:50 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] Add S32N79RDB UFS support
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
 NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto
 <Joao.Pinto@synopsys.com>, Hannes Reinicke <hare@suse.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>,
 Fabio Estevam <festevam@gmail.com>, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com
References: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261024122533.3609180-1-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/24/26 5:25 AM, Larisa Grigore wrote:
> This series adds support for the UFS host controller found on the NXP S=
32N79
> platform. The controller is based on the Synopsys DesignWare (DWC) UFS =
host
> architecture and requires S32N79-specific M-PHY initialization/calibrat=
ion
> sequence. It is compliant with JESD-223D "Universal Flash Storage Host
> Controller Interface" v3.0, and supports up to HS-Gear 4 speed grade. I=
t is
> compatible with UFS 2.1, 3.0 and 3.1 devices. The MIPI UniPro is compli=
ant with
> "MIPI Alliance Specification for Unified Protocol", v1.8. The MIPI M-PH=
Y is
> compliant to version 4.1.

Please take a look at the report below. It comes from an LLM and hence
may include errors:
----------------------------------------------------------------------

## Main finding

**Patch 9/10: PRE_CHANGE errors are ignored.** In=20
`ufshcd_link_startup()` the core calls the PRE_CHANGE hook without=20
checking what it returns:
```c
do {
	ufshcd_vops_link_startup_notify(hba, PRE_CHANGE);
	ret =3D ufshcd_dme_link_startup(hba);
```
So if `ufs_s32n7_link_startup_pre_change()` fails, DME_LINKSTARTUP is=20
still sent. That covers an invalid `one_us_tick`, an SRAM_INIT_DONE=20
timeout after up to 3 s, a calibration failure, or lanes not reaching=20
Hibern8. The error codes and the `dev_err()` calls in that path have no=20
effect. Either the series checks the PRE_CHANGE return value in the core=20
(with an audit of the existing hooks), or the commit message should say=20
that these failures only get logged.

## Per-patch comments

**Cover letter / all patches**
- The subject says `[PATCH 00/10]` without `v9`, but the body says=20
"Changes in v9". It should be `[PATCH v9 nn/10]`.
- Patches 1, 5, 6, 8 and 9 start with `scsi: ufs:`. Drop the `scsi:` so=20
they read, for example, `ufs: dwc: =E2=80=A6` and `ufs: s32n7: =E2=80=A6`=
. That matches=20
patches 2 and 3 (`ufs: unipro:`).

**Patch 4/10 (Hibern8 TX FSM polling helper)**
- The prefix is `ufs: host:`, but the helper is added to=20
`drivers/ufs/core/ufshcd.c`. It should be `ufs: core:`.
- The commit message names `ufshcd_check_hibern8()`, but the function is=20
called `ufshcd_dme_check_tx_hibern8()`.
- "Unlike the initial implementation, the timeout error is now reported=20
only once=E2=80=A6" describes earlier versions. It belongs below the `---=
` line.
- Please don't use `extern` in new prototypes in `include/ufs/ufshcd.h`.
- The HiSilicon and Qualcomm messages used to print the TX_FSM_STATE=20
value(s) when a lane failed to reach Hibern8. The new helper only logs a=20
timeout, so that diagnostic information is lost. Consider logging the=20
lane and its last state.

**Patch 5/10 (move CREG helpers)**
- "Dropped `static` from =E2=80=A6" is not in the imperative mood.
- The commit message should say why removing `static` matters. In=20
Versal2, `phy_write_attrs[]`/`phy_read_attrs[]` were static arrays that=20
got modified on every call. Two callers at once, for example two host=20
instances, could corrupt each other's values. The move fixes that race,=20
which is worth stating.

**Patch 9/10 (S32N79 driver)**
- **Hard-coded lane count:** `s32n79_reset_config[]`,=20
`pwr_change_phy_regs[]` and the calibration tables only cover lanes 0=20
and 1. But `ufshcd_dme_check_tx_hibern8()` is passed=20
`hba->lanes_per_direction`. Use a fixed 2 consistently, or check=20
`lanes_per_direction` in `init`.
- **Connection setup:** `ufs_s32n7_link_startup_post_change()` repeats a=20
subset of `ufshcd_dwc_connection_setup()`: local attributes only, no=20
peer attributes and no `N_DEVICEID_VALID`. Please explain why the shared=20
DWC helper, or `ufshcd_dwc_link_startup_notify()` with a=20
`phy_initialization` hook, can't be used.
- **Unexplained settings:** `UFSHCD_QUIRK_PERFORM_LINK_STARTUP_ONCE` and=20
`hba->spm_lvl =3D UFS_PM_LVL_5` need a reason in the commit message, for=20
example whether power is cut during system suspend.
- **Includes:** `FIELD_PREP()` and `GENMASK()` are used without=20
`<linux/bitfield.h>` or `<linux/bits.h>`. It compiles only because=20
`ufshcd.h` happens to pull them in.
- **Nits:**
   - Use `u32 data` instead of `unsigned int data` for `ufshcd_dme_get()`=
.
   - `SCM_ONE_US_TICK 0x2CU` has a `U` suffix but `SCM_STATUS 0x30` doesn=
't.
   - The comment says "SCM_MPHY_RAM_CONFIG_STATUS" but the macro is=20
`SCM_STATUS`.
   - The `dev_err()` in `ufs_s32n7_link_startup_notify()` repeats=20
messages that the inner functions already print.
   - `device_get_match_data()` is called in both probe and `init`.
   - `ufs_s32n7_remove()` is a wrapper that adds nothing.

**Patch 1/10:** the change is fine. The `Fixes:` tag is debatable: the=20
old positive return of 1 was already treated as a failure by `if (ret)`=20
callers, so this isn't really a bug fix for stable.

To check these points I read the code in your local tree (`locking`=20
branch). I did not apply or build the series.
