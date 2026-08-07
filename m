Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A50A272E6D
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786118463; cv=none; b=egGzcp3d+u0H6mLd9B1jESamLcnsYT+qWEhMhsD4fqhmhx/uNyAMcNljuEEenuVHKy1mjhCicFOuB+6aMqMByEsveRSeqqXBg+N2ZPRC1PqMxwQk1qXvxXeIkuyfrMJE2pDNbWAjpShajpgsUWM0zUYufQMGlW2ckDkcCx9YoTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786118463; c=relaxed/simple;
	bh=d3h3tXBhpkAH9j/OZi79s6FRaMEUG6SQV8uhx+lwJSE=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=XsekXIMTZctrWGZKpofp539YQBGBzM2cSS27WmjaFu42InbBejOmiOFPH5w3/dx0oqP30F/4iz+ArAEegtTKEAgg9aRy4WnJWMBVTbhaSAAy6IK+6pAKogX2kejSj/IKjHFE4mAdT3nUDq3eNXlkTowuCMSHrAY1ijEIVIpPx4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OdL/I44n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OdL/I44n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0DF1F000E9;
	Fri,  7 Aug 2026 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118461;
	bh=whVB7H27AD2w0GWed9Lmg84VdTEcQ7A9F10+lSHqhng=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=OdL/I44nN2fesP1u/FsoUDUlMTV0Lx8fSm/JP3kadZMZr55T/y07uRRF+5sXoLTL9
	 ga9BevUEuccK5PJzd7CKdr/eYWBFBf7zQ5gXE8cIlUxTfVwh0ESso9CXw1vveUAQeF
	 06T2K3eV1a6IfDCrw9i9tqz4c0iDkQNnZGoAo67Z0+meJ3z5QSIC+NQQrFF1ZYLwNm
	 YihJIn3gOZqY4UbqB5P7m+09DMdAyp4guLS3Wa9cxMLhRg3LLNKbz6fSFTB0elKbL/
	 tHV8gqG5Do/1w1xiz2X9qUMD3xnw+nm353C99xW5SDE78Scb9KJZR95VLPzTSh+f9s
	 EZYQcQ+FXhcpA==
To: Dongdong Hao <doubled@leap-io-kernel.com>
Cc: <James.Bottomley@HansenPartnership.com>,  <martin.petersen@oracle.com>,
  <dlemoal@kernel.org>,  <hare@kernel.org>,  <hare@suse.de>,
  <yjzhang@leap-io-kernel.com>,  <kezijie@leap-io-kernel.com>,
  <jzzhang@leap-io-kernel.com>,  <baikefan@leap-io-kernel.com>,
  <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v5 0/2] scsi: Add LeapRAID driver support
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <cover.1785823793.git.doubled@leap-io-kernel.com> (Dongdong Hao's
	message of "Tue, 4 Aug 2026 15:02:24 +0800")
Message-ID: <yq1tsp53oq3.fsf@mail.kernel.org>
References: <cover.1785823793.git.doubled@leap-io-kernel.com>
Date: Fri, 07 Aug 2026 12:00:59 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Dongdong,

> This series adds the LeapRAID driver and its documentation.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
