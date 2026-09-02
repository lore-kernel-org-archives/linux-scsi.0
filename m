Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E0235B634;
	Wed,  2 Sep 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369197; cv=none; b=lmn7znRjDi1/6b0blLeFdvXgzrvB2C/feZyENuCk23/mh7KhYEfpkvadXE+c7iQStK/XUUboa0mHVtt7MVkwQyPifVWv6L5FhOMBYdDMHrTS5pX2S/1zYPZETyWeUDzxeOkJvE3gxiF5z64/MmDhRNUDvL4NDclSsqvYnLb7Yrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369197; c=relaxed/simple;
	bh=6anMubceSpV618RjV/kxu3AwTNrPBew7/pBiDW7LJk8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gRPn4vHVEWpALgfxLvAopZOLxz1swauIhjpqY1+kuPX8rXmfw9qSlGaVH4mO0IdZV6ze7QIbyrh+Tj1VUM6g7kzilCg/6Kbd2dBGfbCSJ/immZhXTpqZo4Pmuk38hljEp3ExphNMx5p13Hij5mSW70ORIIeTkycy5wFsMv9e+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSZMjcTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSZMjcTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722E1F000E9;
	Wed,  2 Sep 2026 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369196;
	bh=e5BnRmbGsWHkiqthwmfSn/F3/mHP9nuYQoZ0GzHNKt4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RSZMjcTMyDMhSJKXPGHQnKn8fHrTLnUwfAd2nBhx8RV34LVpIoGbMh7P5utweNPjO
	 IyS3oy6GcDY+84L8FH/C0yy+HyyPLIlF+EhbvlkxBmgT+9aQzvVHh1IQUSZEoF+pva
	 MX4lH303jOOgRaM3pa4LmZHmUjsDFNcqPvJGYraldQHMpVhVNXSuaUCztW8xcodlb6
	 xWbXriPA4lgAQsLzXN2CMtEjPRjzgmiU6+MdDCNGSh7z2HLWvOppg0aujbqFC/MfxE
	 fIedBbsJm7heIj/dDL9Wj4mj3h6kfE2eCBzvdrqzy0jQaTRoQiUi8Wir+ZBx4+yJL+
	 XSidlwcxq8dOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/9] driver core: separate function to shutdown one
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260902170734.95504-5-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-5-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:13:15 +0000
Message-Id: <20260902171316.4722E1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D4

