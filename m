Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B591433D6DD;
	Tue, 30 Jun 2026 22:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860210; cv=none; b=uW1J9IKZQVNH/XDTqO9S9D1emHbHyoc1qNvsgxHnKQkyNpEbONSc7g5k/uYiuaBhe12mAIsmBVq22zMbrvpkyi2Y9/GZPXr3NU4ZVVJxpRdgfPh1mzAqH5mn/ujyFP/8kCZTgEg1gDiKaCHmxsGomYhNHyvA1OMZumrSIunU1xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860210; c=relaxed/simple;
	bh=zvqcF5f1eGfn1w41feSdZPPmP/1sfTctKQJg9SN7/EA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B9UPLA8b4/bienoPG1UXClnrEq7YG2C0Po3C1E31s2lLcSkK030PRg6YZ0Y5/Af5LNkxXe8P8DkL4mPrQN/JYN4Tpvk2NTMVhP3GU3eRQ09n9xL3VOsRpRQtrsQdLePmLxge0wSulV9hfMaJfXDlzMiFpHqWgOlsfwaWvPS2YOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=djl45S7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="djl45S7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAEC51F000E9;
	Tue, 30 Jun 2026 22:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782860209;
	bh=zvqcF5f1eGfn1w41feSdZPPmP/1sfTctKQJg9SN7/EA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=djl45S7DzjjR5q20+a3zvTS8GRExdAGTJ9jQ2mi9hHgahK8cgBGPBIJ5bOVEUhTMK
	 h4M4jga/ZhCKUkVWsDQ7ELwAMzeE1JH4/pEcTid9OZbRzm/hSDOSBFxDD1kUpwb0P8
	 kfwLrknmL2SUsy/UA2oqZmVIC7ilv1GsI8xdUhRDfkZZl+PZiFQgKshYG8YkQ2Reiy
	 UjVYlGSgQXDS1aXwdD7bZG9pKPi6tdwbmQAwpYIiL2AvFqHhCSoX/K/TUC4mXGnIri
	 5qrjtaqTvUN945jpd+R+AXn5a5WozbZTSdlt0Ytu+tftTUpLTsik0LGBiH4lI807XY
	 9wIxa+CwaasVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/2] scsi: mpt3sas: add IO Unit Page 7 config
 accessor
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis Sautier" <sautier.louis@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org
In-Reply-To: <20260630224922.2543096-2-sautier.louis@gmail.com>
References: <20260630224922.2543096-1-sautier.louis@gmail.com>
 <20260630224922.2543096-2-sautier.louis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 22:56:48 +0000
Message-Id: <20260630225648.CAEC51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Add mpt3sas_config_get_iounit_pg7(), mirroring the existing iounit
> page accessors. Used by the hwmon driver added in the following patch
> to read the IOC and board temperatures.
>=20
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630224922.2543=
096-1-sautier.louis@gmail.com?part=3D1

