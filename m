Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFFA35F192;
	Thu,  3 Sep 2026 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405033; cv=none; b=H5VJyx7wI4E+bkNwPs81LM3S8KOwAJCJEkQLGePYBRKYoUns0nR8Wz0KBY1FLcM6X43QzySo29MBbnYy7F8/cv7YRfnFOtAOScf+eqWdBa7LNMDM9a2k93NUXwYVDBOtW1vdxau5PvAFCwCAiFyfTasc8sEbj8vyvBtbZ0inwcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405033; c=relaxed/simple;
	bh=GC3V6d5LVyN9ZapyIohub5pUzEXZEte0qmAaoPWM6Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2479u/q8R3cQStpgaIxoegVwyN0kdyHgz+FOxEgEPt5qrjHfrxApFb+whPQkHVHNU8bz9iEX58OZiBNdYDMggs4oXasmz3lgpMzwGp2OLQANflxIGL8aDdJ7SJHY8gkNXNpDPHATfy4kcBiHWDDhgeHwUskH4aZYfZPzC9idm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDHv8NkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDHv8NkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A551F00A3F;
	Thu,  3 Sep 2026 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788405032;
	bh=zeX7gtYKN89Liuupi4nVllGGrXh/cbBcQafIcyPbjlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDHv8NkNoU8bG2mcjp7JptwceT+0ZBtXCtVl8Qe6v/zu45TLrxyoyipkY9P7CkUhI
	 Q7sQRu0vMANOO04OLKpmaifttfzOIYFQoKHNvvF2xy02fZdSrtOcKdmB4vVW6gNKoO
	 3Mf4U+3dHt2Col2NYEaA9FUOFtp21KaHn1QtSBDKZlJcjVTKTbCTfSj8oTlUJkgJR/
	 D4j6HFAtAMhBT65giexJP+9FbZE7tkJIDKMySIf4JaCmXwpIlTh8nXxdotB6PZYffr
	 mXhVl7jjESVXOHttmRqmbT/QG/1MrjOF5flKReYLxSEoWm4hs42y4cfT33iwDGoz9W
	 sQbvGzeKhNDaA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: mani@kernel.org,
	James.Bottomley@HansenPartnership.com,
	konrad.dybcio@oss.qualcomm.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH V2 0/2] ufs: ufs-qcom: Fixes and optimizations for Qualcomm UFS Controller
Date: Wed,  2 Sep 2026 23:10:11 -0400
Message-ID: <178840472586.670675.7481898545515362226.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
References: <20260825145203.265579-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 20:22:01 +0530, Nitin Rawat wrote:

> This patch series introduces few fixes and performance optimizations
> for the Qualcomm UFS host controller driver to improve performance
> and to align with Qualcomm UFS hardware programming sequence.
> 
> The series addresses below issues:
> 1. Hardware programming sequence alignment for UFS controller v6.2
> 2. Performance tuning for sequential read workloads.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] ufs: ufs-qcom: Restore HS/LS link startup mode for Qualcomm UFS controller v6.2+
      https://git.kernel.org/mkp/scsi/c/a3756f53baf1
[2/2] ufs: ufs-qcom: Fix sequential read variance
      https://git.kernel.org/mkp/scsi/c/b2ededcb271b

-- 
Martin K. Petersen
