Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0B45516D;
	Wed, 26 Aug 2026 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757627; cv=none; b=hogGQDLeXM0MwPCwLBYUygVWJb2JKzjO2p/gFI6Hkv2Rz31HB6d0yuMPhjHgfe2QEqDouBJzvpDVlsakXs8q9r4ByrYp8SC5zcEakjN3MWiFFK4n3bxG3Srs0wLJQAsUynoMwUGInzyzoSENmlUrMyGz6y6I3MGYk66LEkeWksU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757627; c=relaxed/simple;
	bh=HyU/hFcOtMqRYDwGH0Id/j/NRlIHaEfgE2xwGgMBrrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EB2CQGNq35yYYbRcTUkya2VYfd6vVMJNg0NkiLw+ki5XAUgGDdVF9GkQfXDE50bEjQEPb7LiMaKhyHmxWN8zemCye4o3Xnw1PbILDSRAv2iYXJZy6n7BItqf/pc+bwxmUkHzFVWuR84PgACv5MLhS2GR3bNt6Hr1d8aKBHGOLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwu6GYgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwu6GYgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B381F000E9;
	Wed, 26 Aug 2026 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757626;
	bh=bQD+sQxz5B05sUVLWPAj1kIbfmCHcNe9AmyOGvUnX+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwu6GYgADRNipSeDh45C20AtDrTTfVTD8JZ6gqw4jRtwyoktNXSj+rp2RvdxedRhi
	 bGnW4gKprAFwsUiN8IPuvstGVvPVvNxC60yV7R4XW7Pm+vdpDtPURWM/At7BVMWztE
	 5m9kfNyHYiHIPhIyh26FkhBy5aFEJdRg/5ZR4vEW3RNdXyHh5DIABLU+GhFL32pUDC
	 KF+P2D+uknQiOo5iyVs5lmyWhz2f/lpK0lLkANatRyVNMShNk+GOZ3Caa9/ZVNcPM6
	 pbz2jit8XznF5qFv+tEPVRP9SgzmSnc4tcNw+T8PgwYH3BvpDw5Rb0vLTO+YlAx4y7
	 uSWPHkNwQHkIw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Atul Deshmukh <atul.deshmukh@qlogic.com>,
	Dan Carpenter <error27@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Saurav Kashyap <saurav.kashyap@qlogic.com>,
	James Bottomley <JBottomley@parallels.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix an loop timeout test
Date: Wed, 26 Aug 2026 11:20:12 -0400
Message-ID: <178775714070.3862282.8414500937555246151.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <an1twcxTYSFkkUTA@stanley.mountain>
References: <an1twcxTYSFkkUTA@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 13 Aug 2026 10:09:53 +0300, Dan Carpenter wrote:

> This loop timeout with "retries" set to -1, not 0.  Fix the test
> for failure.

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix an loop timeout test
      https://git.kernel.org/mkp/scsi/c/11e48f5201fd

-- 
Martin K. Petersen
