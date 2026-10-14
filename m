Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DF371CE3;
	Wed, 14 Oct 2026 03:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950236; cv=none; b=e+DNQJ3jv1rwnecfxcpMjG9zsEM9mTReK5S5MpvD1QPcx6l84yMH2Wds9oiphJkwaVbfDaVM2Cwa0Ph5+Y/JSkU25F4NOhYaKnKSbbtqLwKioEUugvLL3U4GfalMlanKdP0FrRCN46BKDzFkg5VyRMNOwxKQQanXc1NLRgf6xfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950236; c=relaxed/simple;
	bh=6LTrs3ZOCnUH/v9qyW+JgmeSw0TC14Mkyl7MK6j6+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WYIFAaoj7whooiWTGaJRgDiwRa/kKLdYy66JMKEO65lQZue9dfQR3k0QBKh075D068eNhGHSFa0Nz9H4yDBMt741B/LljfoqVCjzSkiqEj1vJI1epyXAFurmMSHzq4KUHaRJCtxInixli8UrxMij/e6mrhms0VUH1VsP4gUe12g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JB01M9nG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JB01M9nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820C41F00898;
	Wed, 14 Oct 2026 03:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950234;
	bh=vsrPzgKO/wGg8y8eXQrA+EyOgv+Gwx69CwhSIoT+HxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JB01M9nGPEplgRC8bMAGUvH5q3e0L0GlvzaBEt4/XvdwNCzSFBvB99NIThH/p//6D
	 FhRBl3XsGWjYMtnR7TbT1/6wj8NW157rqHQb7SLhFEF3pWYBOHnFKVPPUMF6zXMtrY
	 QcPsbnaij953Ef1IGWIigJkOf2+c1uuNUxcRhOVUtPsj1kgqzxBfs/5Lpdm3lJfzyF
	 3zZETi+ozcUzuAxlRDqUpdnTe+zpqp+5FXxtWtr4ZK3BYBFmJKnQKRIOcxBFwNWuio
	 1mPxbD00LJYIxdlCNPo0bW5HSCthUNI4EVzJfxOZUtmhcfFh0D4R5xZaffdQKfxE34
	 rhXu7nOMmPudQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	morbo@google.com,
	kees@kernel.org,
	justinstitt@google.com,
	codemender-patching+linux@google.com
Subject: Re: [PATCH v2 0/2] scsi: bfa: Replace strlcat() in symbolic name construction
Date: Tue, 13 Oct 2026 23:56:49 -0400
Message-ID: <179159633708.2229379.16556684889562662084.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 02:00:28 -0700, Mariia Nikitash wrote:

> This series replaces the strlcat() uses in BFA symbolic name
> construction with snprintf().
> 
> Patch 1 converts bfa_fcs_fabric_nsymb_init().
> Patch 2 converts bfa_fcs_fabric_psymb_init().

Applied to 7.4/scsi-queue, thanks!

[1/2] scsi: bfa: Use snprintf() in bfa_fcs_fabric_nsymb_init()
      https://git.kernel.org/mkp/scsi/c/0a5b53c1e727
[2/2] scsi: bfa: Use snprintf() in bfa_fcs_fabric_psymb_init()
      https://git.kernel.org/mkp/scsi/c/6697e9f202c1

-- 
Martin K. Petersen
