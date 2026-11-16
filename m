Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794790142;
	b=tPbxDlpx9MI0z/TMVzOs3xSmgSz1llXkojNMnQManByZwGoDTkwpsUPVtO6bsOxBdTOw
	 BcUmspgNmL4LdAbE7v8NF7fgIUvXVTH5pehbeaR4QbxaXVDfrk/d++PYSc/mlovRbgSsl
	 9vmCopEZwqMTx80GzwkakXFbpMR7Kf3E7M8FYeS54eP+U+UJTvIuFo2zAS5rqgi5a1B7B
	 vZhRCK9RRawZeKgM4gLFf4KdE1z+5dUhu+MfNptwSae7zCy76Hepb1v6SFQLm/yjj6lnR
	 SD6Vf5p5cG9YxU6rOPhOGkTuElbwBmJ8nQnOWUKsBPbFKOVPPaIdHMKixR1FJYK67GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794790142;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YnLCqcFhmbMlYSdAi8bGMjTODnmFcZXJBeAyDuNeppk=;
	b=SR2IO1+8BvhAYK/jpyy+aIOBW7TTdjcK8YGXuIZvtCY2K8ZkB6Cg32eEuCOxU3BJZfEp
	 vX3rSnkWAuDxmSZnllGsxg78quRrEUlXQY0uBCAXpumQPdGkg4HYs5XuoHbQyAHslMuHc
	 0ewcUl1dCzSxIUdl1pMb6IU0oblR6HCTVok7gRarkRkigBDlFXrO3qAPwEpNiC7+QsrW5
	 GVczF5B8oCO7VhCIYCJet0dBy1dlqdFRRZ24B1LhDZKaTD0VzkahXrKbcTkGFI8GWp6Xu
	 uAgd3NA5BcC3ynpBkPcWMvPU57AWiyOr6lzn8GJnoNyGbfsvGQezBmmCintrXTNRA5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iO+cukz8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213A3606A32C;
	Mon, 16 Nov 2026 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iO+cukz8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDF81F000C4;
	Mon, 16 Nov 2026 00:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794790141;
	bh=YnLCqcFhmbMlYSdAi8bGMjTODnmFcZXJBeAyDuNeppk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iO+cukz8stSFacPVXWenOIamofRfaJNchDAtODHncdWIRYekjE1wrGIWUa9bslDT2
	 4aKX4fTGamh/xjTL+syg5c6g9vLmeZMv7ZIk+nlEhBMEfNhwtUN4Ojk3ZXuyPge0+L
	 SvGPGYiky9xpBcEEDXNV8s6PxqZJmUcqutBDCpuWurgl3r3BPIV2Qgssnzv5/b0OAp
	 M4TvS6qMLs4uNJHl+n3xs8G0hEW/k1AwYQf/pV5LRX3ic3gdTNRLRSj6+y0L1Oiwxy
	 rFsMJU3HON5VDIhrgA2Cwyjp7f7lcAZc+MjRc2aGXEwAWiUmd7idiyq5KYV9Sbkpn2
	 PM+lB0S//GqXA==
Message-ID: <sashiko-outbox-215971@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 17/18] selftests: target_core_uring: Test a device
 exported through tcm_loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <qiliang.yuan@linux.dev>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20261115-feat-target-core-uring-v1-17-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <20261115-feat-target-core-uring-v1-17-28cdc137eac6@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 00:49:01 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] selftests: target_core_uring: missing CONFIG_SCSI, sd_mod
  load, and dev check
- [Low] selftests: target_core_uring: mktemp leak on skip and missing
  EXIT trap
- [Low] selftests: target_core_uring: hand-rolled TAP output in
  tcmur_test.sh
--

commit 6f0f6d18ce018c3449526ab2ffc205257d98be91
Author: Qiliang Yuan <qiliang.yuan@linux.dev>

selftests: target_core_uring: Test a device exported through tcm_loop

This commit adds a kselftest script and kernel config fragment that export a
target_core_uring device via tcm_loop, serve it with tcmur_server, and veri=
fy
I/O, server restart, and command timeouts against the backing file.

> diff --git a/tools/testing/selftests/target_core_uring/tcmur_test.sh b/to=
ols/testing/selftests/target_core_uring/tcmur_test.sh
> new file mode 100755
> index 0000000000000..99f68e74c7cd0
> --- /dev/null
> +++ b/tools/testing/selftests/target_core_uring/tcmur_test.sh
> @@ -0,0 +1,137 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Export a target_core_uring device through tcm_loop, serve it with
> +# tcmur_server and check the resulting SCSI disk against the backing fil=
e.
> +
> +DIR=3D$(dirname "$(readlink -f "$0")")
> +KSFT_SKIP=3D4
> +T=3D/sys/kernel/config/target
> +C=3D$T/core/uring_70/tcmur_test
> +WWN=3Dnaa.5001405074636d75
> +L=3D$T/loopback/$WWN/tpgt_1
> +SIZE=3D$((256 << 20))
> +IMG=3D$(mktemp /tmp/tcmur_test.XXXXXX)
> +PAT=3D$(mktemp /tmp/tcmur_test.XXXXXX)
> +server=3D
> +dev=3D
> +fail=3D0
> +
> +[ "$(id -u)" =3D 0 ] || { echo "SKIP: need root"; exit $KSFT_SKIP; }
> +modprobe -q target_core_uring && modprobe -q tcm_loop ||
> +	{ echo "SKIP: need target_core_uring and tcm_loop"; exit $KSFT_SKIP; }

[Severity: Low]
Does exiting on the root or module skip checks leak the IMG and PAT files in
/tmp?  IMG and PAT are created with mktemp before the prerequisite checks, =
and
rm -f "$IMG" "$PAT" only runs at the end of the script.  Without an EXIT tr=
ap,
an interrupted or timed-out test run also leaves IMG, PAT, the background
tcmur_server process, and the configfs entries behind.

> +
> +check() {	# <name> <command...>
> +	local name=3D$1; shift
> +
> +	if "$@"; then
> +		echo "ok $name"
> +	else
> +		echo "not ok $name"
> +		fail=3D1
> +	fi
> +}

[Severity: Low]
This isn't a bug, but could tcmur_test.sh source
tools/testing/selftests/kselftest/ktap_helpers.sh instead of hand-rolling
KSFT_SKIP, check(), and the skip messages?  Using ktap_print_header(),
ktap_set_plan(), ktap_skip_all(), ktap_test_result(), ktap_test_skip(), and
ktap_finished() would emit standard KTAP headers, test numbers, and summary
totals.

[ ... ]

> +	before=3D$(lsblk -dno NAME | sort)
> +	mkdir -p $L
> +	echo naa.5001405074636d76 > $L/nexus
> +	mkdir $L/lun/lun_0
> +	ln -s $C $L/lun/lun_0/tcmur_test
> +	for _ in $(seq 40); do
> +		dev=3D$(comm -13 <(echo "$before") <(lsblk -dno NAME | sort) | head -1)
> +		[ -n "$dev" ] && break
> +		sleep 0.5
> +	done
> +	udevadm settle
> +	dev=3D/dev/$dev
> +}

[Severity: Medium]
What happens in setup() if the SCSI disk never appears in lsblk?

After polling for 20 seconds, dev remains empty and dev=3D/dev/$dev sets de=
v to
/dev/, causing each of the four setup() calls to stall for 20 seconds (exce=
eding
the default 45-second kselftest timeout) before running dd and blkdiscard
against /dev/.

This is easy to hit in minimal test environments for two reasons:
tools/testing/selftests/target_core_uring/config sets CONFIG_LOOPBACK_TARGE=
T=3Dm
and CONFIG_BLK_DEV_SD=3Dm without enabling CONFIG_SCSI, which both symbols =
depend
on (CONFIG_TARGET_CORE only selects CONFIG_SCSI_COMMON), so Kconfig drops t=
hem
when merging onto a base config without CONFIG_SCSI.  In addition, the
prerequisite check at the top of the script loads target_core_uring and
tcm_loop, but does not load sd_mod (for CONFIG_BLK_DEV_SD=3Dm) or verify th=
at
configfs is mounted at /sys/kernel/config/target.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-feat-targe=
t-core-uring-v1-0-28cdc137eac6@linux.dev?part=3D17
