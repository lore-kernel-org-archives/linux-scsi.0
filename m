Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6424657DA;
	Tue, 16 Jun 2026 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624686; cv=none; b=M62IJoAU1tQzDZOUrrm/IOoYk1chPCYTu7HCFnzjrLb0lqJUfiYIHHyk01VdW2ztcrzbbijJ0Ye+6FDj+BaFZiMQaqhxby1rFTo3M8k73GtRjDabHF1DEoUJUx79zr2PBZFQmBPsoekRXnZX1Sd+MfuBmaTqYJfhstjfVbfS2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624686; c=relaxed/simple;
	bh=J+qJJA7KpvJIR0RESySPYWW5wX4Z+35apqrixSESdbE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NssjcgGDfmiEv/tr2HaQncQC8pBUchi/wMcUGFPs1sp1BEEPbeSKvQXqy7ZYflwiW/ZvRrw18+PyYJz861uoIVUX6Wv4Y/AR7vVompwytAy5EF+vRaCUDgSP3UdLnCei+PSJF8sycJvjbSPNB1F92sj4Khc5R32khre3HCH9ob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDAr7ML6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDAr7ML6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0272C1F000E9;
	Tue, 16 Jun 2026 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781624681;
	bh=J+qJJA7KpvJIR0RESySPYWW5wX4Z+35apqrixSESdbE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UDAr7ML6Jl2mTDVvMUJFQRZeF1J4sLtn7AD+NG3sP/qTUxDLOZHgE9gnrvNOC7jzm
	 WzapBZPcaos4GboyB8NqrhcPyzuhSdKeQkhRN11qdSCIWIMTxlbhtd7aHNzGTUN4H+
	 QBedkcwD2S+iSF3NF9cV9Uaa+vfmuu7qkdYVFWmdqLwf+WZNN8stD8ZNE7FyrKs4El
	 3lpZEHsace+qFqjgFpLLfAJg2lg0j8WprZ2Tpm2EPqwMe/LR8Xhvhi64Z3VjqT+1oM
	 7vlhQ+iwJ39WyOKMUE9KtACUF42D+Wd89pImUe0mouVJ13mjpDiNk5N17kIpv1M3yb
	 CxERw+ueOBLOQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] scsi: Enable async shutdown support
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260616152219.6268-6-djeffery@redhat.com>
References: <20260616152219.6268-6-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 16 Jun 2026 15:44:40 +0000
Message-Id: <20260616154441.0272C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Like scsi's async suspend support, allow scsi devices to be shut down
> asynchronously to reduce system shutdown time.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260616152219.6268=
-1-djeffery@redhat.com?part=3D5

