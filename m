Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DA94C6EF6;
	Fri, 21 Aug 2026 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322571; cv=none; b=IzRtUe2hQUTlYg6KIFSN19K84auTJy4U3XywkkeGWoFrIdWUVVFhwPmRvZeXk7cXv5027AwG7Y8ViGpKG6zzJZN3fLoEhJCZHi9KLzS1Uk/vGU2wEmcbI/IG6NXGCcpx6KHbxq6tzuxilWQl9Wtc2YCrEBtaXk5KWWdCXtNDNSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322571; c=relaxed/simple;
	bh=Bm6DbKzWbfnu+hJvycNsYkoUyrySXMCU6X9CbalbcaM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VLIyp7hPyTwLfQLQ2frm0LFhbIWGkggNshlWKlVUN73OQIEX7BdblblIleVBZ4n/2VnhdWrzIWxPmFY5P9rZKQ48gO7G0a++3lROXUF5NUrqVzXnLA9xSpNdQZj8gf8aUf30i40CxPBefvOEqeNYehTSPa9dvGnJjDSivq9riPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HYK0a9z1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HYK0a9z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDC51F000E9;
	Fri, 21 Aug 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322564;
	bh=pzZcsVhm7xZQUGqRSvnlW8F0JEnIkbYZCBUJEUWtHio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HYK0a9z1B+r8ungG44XwNpwQ8bQA91e3MgvVoXPnJS0BVT7IiXicHjZUHclE9LBg5
	 11UpQSdO2Cx/Atj5TAEKuwqhglAvsSETb8IgfFg9Eigod9tZXKQ3VQzsGwYiR7opRR
	 6lQjZvDmgKas2/7XnwAly3fKRB/6jkO2D0oNy/30fA5Rhcth9DTTu1gX5Zi0qyrkV7
	 jGJCrNkdfRRmGb1HmdroXbwoQiHi4Iwq9SyS8svqnHltNLFygqVq/CHgOEuQ9rBa4g
	 gGvS+dDXW6ms+m1ul+RIRHTBWif0xttNs2swuX4EU75OLgzU61nmvXvPH+9qm+cubX
	 nBt8PN939NPZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260821142414.150892-5-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-5-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:29:23 +0000
Message-Id: <20260821142924.6CDC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make a separate function for the part of device_shutdown() that does the
> shutown for a single device.  This is in preparation for making device
> shutdown asynchronous.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D4

