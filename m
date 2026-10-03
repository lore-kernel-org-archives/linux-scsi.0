Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7818A93F;
	Sat,  3 Oct 2026 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791035126; cv=none; b=EdJ1EXPU6M9pM3uQ8nnAaSC/5A34XjjDWa2qRu+XrhJ9KTk8r/cLDxbMLGgNADLWXxshQ7rVSt+Layal4iL3WSPWRRX1sacXneXBdsOgPw5Pp1eM46Zmd0BYINmGMY4JdPqQgzFa/c4XKjH3ue+HgD9CqY8TG3TVLLiFpPASECg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791035126; c=relaxed/simple;
	bh=Y7Ywwzu8NuM6vtY/DWkLFTM+5v3/SM41mDVeigKs8U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAg8MmSUHyFbiJUtogO8IL4skteNfD3sxUsJtBOY97k8pglnkMSsh4RY5zFVAfA26REDK6lcGoBYF8ZfcplKDh4Ljq1l/dN2o80+AiZZpKyEGkw6Dx4dqzK585iVQHcJwhc2W0ff49jgwCb1PbJcIKdoVr50bsvAoSoSU6FK8Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MG8uCThF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MG8uCThF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D121F0089C;
	Sat,  3 Oct 2026 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791035124;
	bh=GGC89lFgk1sLFM+oUhmJ1NYszo7HHefdGllF1fwud3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MG8uCThFNEG96kp6A7eXpyYpXTJj1UvqrwnejJZOCrWNuDF+HZMyBuxRb6UVGB3m+
	 fUQwwLmz/p+eQLn/XbmF/3dpqQ23hHya8chTWKdt/RzV6+Wx9UB3wk1lqh7e35KDDU
	 zoPtDjMH4R5LZHPLKjlMffkP4N9FEcru3WNDsHRSmD9uBLCvNdnW2bFShhRwwKoGMN
	 NRkRlgPXAlaHAKWCR13/EiTxzcrWF9OyqgQFz2Xd9sC7bEDnpyytJhgkn/FWfheNIQ
	 VgmQmWtXQvwZb7Mm2hiAKhn0K2YNqPA+2Gdz2fwCYlv0rngyvKvQW25lityvx2p4PE
	 hMBPUY6CjbHjQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Peng Fan (OSS)" <peng.fan@oss.nxp.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH] target: use assign_bit() where applicable
Date: Sat,  3 Oct 2026 09:45:20 -0400
Message-ID: <179038630277.128504.15685519010575222951.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919130853.3041614-1-peng.fan@oss.nxp.com>
References: <20260919130853.3041614-1-peng.fan@oss.nxp.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Sat, 19 Sep 2026 21:08:52 +0800, Peng Fan (OSS) wrote:

> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.

Applied to 7.4/scsi-queue, thanks!

[1/1] target: use assign_bit() where applicable
      https://git.kernel.org/mkp/scsi/c/f09d2c7485b3

-- 
Martin K. Petersen
