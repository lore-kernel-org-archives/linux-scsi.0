Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F24238F934;
	Thu,  6 Aug 2026 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024253; cv=none; b=DekznPJnKY4jKIjP/CM7GJxMInWl2T0ZTHgFoF9twDNxWJnQY6TEdCqmhS1mr7N5aKuLMLwAzaurltk3brKtq8sn1znONZiXPps60b/CwPpA+izcR5uO2Mq0rUugD/ZjPjj9K1IHBCmj4808YXkgk67P3xoB2hSxXwrF04y+ejM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024253; c=relaxed/simple;
	bh=6eLNjeMUDg45XPwgomr+ea6gkn8WehR8+aLyS2m4K34=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LFFqPQg2M2o1kLlEBWv+tscT/lndbddcQNNlulmQWdwiz5uQDtSyZCvy7ewfBQtuoQ/99VZDe6UP08lKx5e7+uMdXx8ocjl+Ss/ZTDycAa/sts/a6DMAoKau41/iGpIbzlKla/XzmK1gl0es+b5EiVX9t1JU/lI3gVjslty+fpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLo2TNz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLo2TNz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7EB1F000E9;
	Thu,  6 Aug 2026 13:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024251;
	bh=6eLNjeMUDg45XPwgomr+ea6gkn8WehR8+aLyS2m4K34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fLo2TNz03ki37nMeJmVQiDzB6wVHjhFkRJiGBPeFJXoyQOpBPlIPc/Cyqwbs1RGxg
	 6Pd5fEYa5oKcUzdFlagUybBKsjzVAauMl7h5LeSdrXkhtOM2uwLh/2KT4mkk12clIV
	 krjw8+0qJW61haZMkQ15Vs4MK8QIDu7Zk4i+JE7ppHr5y8e8iu1Rq8pj556EvklhUE
	 4a0XMhHhlHpCRiGUvUxZbYikf/owJo+7+0hEANKYPYc7zZcn30lu+idzZ4R7yeCitn
	 CPXN/RGuT0Ggj3nQTjrKCEDof9YGzhoi5xmgfC3h8MBGyTF1ZtxxHdAOD2nd5argQ3
	 WgRe4LRUxFv2w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: zfcp: Enable CONTEXT_ANALYSIS
Reply-To: sashiko-reviews@lists.linux.dev
To: "Heiko Carstens" <hca@linux.ibm.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org
In-Reply-To: <20260806134759.2122369-3-hca@linux.ibm.com>
References: <20260806134759.2122369-1-hca@linux.ibm.com>
 <20260806134759.2122369-3-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 13:50:50 +0000
Message-Id: <20260806135051.7A7EB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The zfcp driver passes clang's compile time context analysis.
> Therefore enable CONTEXT_ANALYSIS.
>=20
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806134759.2122=
369-1-hca@linux.ibm.com?part=3D2

