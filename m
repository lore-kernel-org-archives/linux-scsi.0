Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998332;
	b=nptx/sAraD06UR3KoN4H0se7eyj4RhB0SmxJcx21Wm9FdGWizgr8VwtasYt/VXX+Uid/
	 tGsHOKD2SjohIyN4FVIE/kYdsD0Ux7tCTwmYjGT7EebXz2Mh1jWWeKumb4tBfoIt8Mgrh
	 pqGdRHv3rJ7PvYUKbA2YkgSBUn3IQ9+37fSAvYh9iDms1xBChZiEJLok3s149sF1ORNT5
	 O8buNUEI+83UfXTrIML2ik3VcnjjThlVnDmlrfagocYx00FJEvz35s9j+tR7dMp4rRpJ9
	 nXVx/G1t3BPzYMLqCoAe+ys2J8uBx9yF+ywuyxx230hM2qw/2WL6M3yOpx9DBbe+cIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998332;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Lndcq7hT5Kil3oKySCuOPL7PMAGTbfkMZbAvwLavh2A=;
	b=Y838+Ja6keB83qM6OBnuWjGB+xU/mvv1N6JV6oFBUsZ5y/rHretiZvKHX7Cp/JjgRSpn
	 IBECYukXd0lHhK4FbqaPaeMPxvL5KVlZ46XVJeERo+8h4U0kQuT2e5NV6w5UamUg2PQjK
	 GnZbnMpDABznTackV4OIvYryd72+3urwg8+09nLYSxeKDfLv/wxgia/ZEOAv43kWv477d
	 AXrA52FPDTRaTL8T+iSs4DLjbK8Ws5Ws7z33u+245qvMLfaC7SwzqZ5x4qOhbiBAk/awb
	 H9ZpvsSLJ0mCGVN9MEAqKGL1KxvG4O67hZ6j9qRIYDrzoWJW8wF4TRLJh2R2uoympgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QixBrU3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE0F606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QixBrU3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB001F000C4;
	Wed, 18 Nov 2026 10:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998332;
	bh=Lndcq7hT5Kil3oKySCuOPL7PMAGTbfkMZbAvwLavh2A=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=QixBrU3W3TDBb1cZDoQe+/0ingcs7ZFFYjldh2A/zJK5yQpitotssWvbiAW6GvorD
	 sECw45gSe8AkzPElZtmsPgD0utTBjXlx4um89feT19K5Y1V0ubGFlzY7oHz3CEvoA0
	 doOshREcjTIdT4PdyTd546b7h5vD/5ARykycndwE0MHMbT124LnHq13opfZxSDVp7V
	 fNUqCwZprNIMaLkmJXz4fAPME75NF4GNpuYQCis9aGlQaK4zAjoYbJvJ9DlFWCtu+Z
	 1J2NMHJ6sn+6/UifRZMkx5fI3NJi5JqgcxQED2N7S86caFs8J0ZUB4ihx7DA56XLts
	 /epLZXFKWgeQw==
Message-ID: <sashiko-outbox-220723@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 32/37] scsi: mpt3sas: Fix out-of-bounds bit operation
 in _scsih_check_topo_delete_events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-33-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:38:50 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: mpt3sas: missing Fixes trailer on out-of-bounds bitop fix
--

commit 7e5a1d39be62ca30c67d676c42b692226b0240a2
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix out-of-bounds bit operation in _scsih_check_topo_delet=
e_events
>
> When find_first_bit() returns a value >=3D MaxDevHandle (no bit set), the
> loop called test_and_clear_bit() with the out-of-range index. Break out
> immediately when the returned position is >=3D MaxDevHandle.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes an out-of-bounds bit operation present since the driver was
added, should the commit message include a Fixes tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D32
