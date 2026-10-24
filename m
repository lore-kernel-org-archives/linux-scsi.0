Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812304;
	b=KpCEo+X/JBkLENl8ZleTIzy89O0ytR+nsso98iMaJwgv6up4eZrdMB1XmAYuFdutFpPc
	 H+ZWHRVw9sACjB5tQWR6ZrVl3OYl6RGG2WLFiI8XZ9As4IFHt9KwmphgBi2xwyLbDCHhh
	 KbrP19aDP8VDTJ73onzRGEx94H8n956NvNWcnIxOdWKyzWNQyFQZJ4N4SIfOtsOviByFT
	 vPEPMqhDzQ1ORHDgz1tZgfgDILq8lRAhvSwmGJ1pKj+z0bemrfPZ/erGWnB4d/mhIGO8L
	 /7w6LPT7/UIgDGVrbGWf+bWX1KNjx7idIAn95SVUICOTL4fwlnnVB0tgo2h/0x5ZLfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=26QPVEavOUEkQdtPoNIE8LbHEk1TOj832+l2KO1TWj0=;
	b=sVmWChAqEQVi5DA5DLodtKlnewicQQYW+euhpLksMQhalpOs02JQkVwbIag2sq8yt1Gp
	 CB51UUQ3TkEhUoxop++PY4ON3bCMCCRDl5iqPMNV5zKctDfdSuP4sHPUps8V3aqTbRcI3
	 4Rgj9qTBC7RMpK9bX9qZDSnHBZ74KNKdDx4XWblk8XW9xFHWsWVViFfQQsuTZtQ3gsM/q
	 HqAcI8Lvo/GixoJyEsvlQcroIdzhN1+nACzrIZ/rqqudexHqmoYK1kS5x1bfaW5NAb7iE
	 zy0O5JjWlNdkYmVO6hOuKr6GGgUUKpSoMVlS4IYo/dm4pddFjEOEUvEVK6lC5TJXhCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdEm1XqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD4606A31B
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 03:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YdEm1XqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B4B1F01825;
	Sat, 24 Oct 2026 03:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792812304;
	bh=26QPVEavOUEkQdtPoNIE8LbHEk1TOj832+l2KO1TWj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YdEm1XqBD0IT/6RTo72JmMKSog2eFT5ladaJHjv6AoB/ahNwF+rknslEgJ2kQ/nt+
	 5q2QahmFSvSZ3wSmaEaa6TPVO21OqmxPEBmJw7kMQYcKYJP+cOS0IVO5FfPNNBQ6Gb
	 xJNjUfwpYfWv3d6OF0Azq5kKqGJ90bVYXt2s7PSQDPhF//Q4ML2YFJibaPU5MO/kWh
	 lft7IQogrDtQBMmN1cKWv8iESqM318nzEZqww9QPDmcQzFwTxxFbimH0B8GIw+my9/
	 H23IAH2sEaXH7X4VuE9VMKJVNa0YeIo5a+3P8u2mibvh3FA7PVhbnShdlJOquA9kxT
	 v3MZfEfF9lgtw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/54] scsi: Enable context analysis for most drivers
Date: Fri, 23 Oct 2026 23:24:52 -0400
Message-ID: <179280384863.3823844.15428056748287072711.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
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
Content-Transfer-Encoding: 8bit

On Fri, 25 Sep 2026 11:25:38 -0700, Bart Van Assche wrote:

> This patch series enables lock context analysis for all SCSI drivers in the
> drivers/scsi/ directory except scsi_debug. The advantages are as follows:
>  - The compiler (only Clang) verifies whether the lock and unlock calls match
>    what has been declared via __must_hold(), __acquires() or __releases().
>    This is useful for catching locking bugs in error paths.
>  - Support for __guarded_by() is enabled. If a member variable is annotated
>    with __guarded_by(lock), the compiler will issue a warning if that member
>    variable is accessed without holding 'lock'.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[01/54] PCI: Convert to_pci_dev() into an inline function
        https://git.kernel.org/mkp/scsi/c/e46ce4e8ef2e
[02/54] scsi: sg: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/c5b5b5786ae1
[03/54] scsi: st: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/d69fcaa34b67
[06/54] scsi: NCR5380: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/a51e9948d168
[07/54] scsi: aacraid: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/44bb77a1afaf
[08/54] scsi: aha152x: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/825b26b342eb
[09/54] scsi: aic7xxx: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/22d469241b6b
[10/54] scsi: aic94xx: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/678dd8c98ef5
[11/54] scsi: arcmsr: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/5a08252a78e1
[12/54] scsi: libiscsi: Pass the session pointer directly to several functions
        https://git.kernel.org/mkp/scsi/c/ae1c0d65bc71
[13/54] scsi: libiscsi: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/bbee7e5b4fd9
[14/54] scsi: be2iscsi: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/901ade3fa13c
[15/54] scsi: cxgbi: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/f3e83f658751
[16/54] scsi: bfa: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/d9a376f43c1b
[17/54] scsi: bnx2fc: Pass tgt directly to several functions
        https://git.kernel.org/mkp/scsi/c/32f9cdb45bdb
[18/54] scsi: bnx2fc: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/9495fadabea9
[19/54] scsi: bnx2i: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/89cb9bbfcb6c
[20/54] scsi: csiostor: Pass the hw pointer directly to several functions
        https://git.kernel.org/mkp/scsi/c/640361f6a944
[21/54] scsi: csiostor: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/7a6d3b98469d
[22/54] scsi: elx: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/8281912eda17
[23/54] scsi: esas2r: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/5ba6b666f701
[24/54] scsi: fcoe: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/f9581845d992
[25/54] scsi: fnic: Pass pointers directly to several functions
        https://git.kernel.org/mkp/scsi/c/ac063a30e80d
[26/54] scsi: fnic: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/70d2304ae575
[27/54] scsi: hisi_sas: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/11c345d6dbd8
[28/54] scsi: hpsa: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/107115c393ea
[29/54] scsi: ibmvscsi: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/256962ec2846
[30/54] scsi: ibmvscsi_tgt: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/fc4f84fdc528
[31/54] scsi: ipr: Simplify ipr_eh_abort()
        https://git.kernel.org/mkp/scsi/c/2a0cb1a2423d
[32/54] scsi: ipr: Pass the host pointer directly to several functions
        https://git.kernel.org/mkp/scsi/c/e2bb4cd08080
[33/54] scsi: ipr: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/9c176edb892c
[34/54] scsi: ips: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/68ce6d43f4ff
[35/54] scsi: isci: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/10385e735e8a
[36/54] scsi: libfc: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/3a6d7333e3f2
[37/54] scsi: libsas: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/4901e49c5c60
[38/54] scsi: libsas: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/554a002f96f3
[39/54] scsi: lpfc: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/b6ac5193c692
[40/54] scsi: mpt3sas: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/8d3d0e8d26a6
[41/54] scsi: mvsas: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/53812028f864
[42/54] scsi: pcmcia: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/202aeb5af5e2
[43/54] scsi: pm8001: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/74688075dd07
[44/54] scsi: qedf: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/cdc1694e333b
[45/54] scsi: qedi: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/6210d20f7fe4
[46/54] scsi: qla1280: Pass the host pointer directly to several functions
        https://git.kernel.org/mkp/scsi/c/5bb1688785a5
[47/54] scsi: qla1280: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/23d5f939d99f
[48/54] scsi: qla2xxx: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/5ed1a2dd293a
[49/54] scsi: qla4xxx: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/20026b0b55ec
[50/54] scsi: iSCSI transport: Prepare for enabling lock context analysis
        https://git.kernel.org/mkp/scsi/c/d5f024412d23
[51/54] scsi: smartpqi: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/78b27248f721
[52/54] scsi: snic: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/e24eedc81ec4
[53/54] scsi: sym53c8xx_2: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/659dec2ce32e
[54/54] scsi: drivers: Enable lock context analysis
        https://git.kernel.org/mkp/scsi/c/782a516e8f43

-- 
Martin K. Petersen
