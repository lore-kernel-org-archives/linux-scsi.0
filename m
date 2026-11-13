Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794562286;
	b=frq6XiSTPORBKoyEJOEywsS5Y6T3UiKjCDcaN013Yqm4y0tS2S9/aDVpmyYZ4xWNjRM1
	 x6a+nd5+iaRrfPszKGGpoSmUzWc637LZ0dPfPFRFxu6vVRuMmhMEo9x5eHsVo4XvYj9DV
	 1wzq7hMNuMnf+idmLlhTW7THdA9VLmRQR3DMXlX4IOMUOYwIysj+fJmBmkkODRfp9Xu1o
	 SuoiCYTdo34Umla77K5n5KnMVmPnUFTrz7GeM0dUMajZj1U8/SLh0qDfwycxpiAgFVyqt
	 8PbAdDxijuq7q5EO+LHzsTymrT5KsguuuHHsWY79Hj9V5tq/ed7IK7h23AVXnDxtTJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794562286;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EMfXNYkZVks7flMrKu46XaAukhBAJVxT9U2dtg8td+A=;
	b=4C1QhFnrcQkJygH/klrDtXq7GR/xXxldX8IdurHDWmtPGBOnW8QOBjk3bV5lcgIhOSMx
	 6M0+0ylABGLOerTPtOYAyU5GQ4SFERRHIOvaN7toeDKydRYPYpmYApmqz/5lWH4PVuG90
	 gVHznuKPDtOdFwvR1yNl/SOY4J3sJrNdSseMn2n+oCR8apAKAWpT1pBiolNJe+Xzg7WOh
	 qAioW8HSjM+2YsYSqkK98zss26clZP+iYxKIQ6Ozr3+b99ynhl6CYU8DPDSTjpyUJ3eSp
	 ai1E6yji9lirGKVc7A4oPANMn57dIBkP0luElSh+reTf29dyFfCO4YaaszYDfN2SEoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=akOqDgwi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1EB606A333;
	Fri, 13 Nov 2026 09:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=akOqDgwi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F2C1F000C4;
	Fri, 13 Nov 2026 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794562286;
	bh=EMfXNYkZVks7flMrKu46XaAukhBAJVxT9U2dtg8td+A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=akOqDgwi1ZOWtxGBNJUwwA0lC8PNQpA7oZJ7gd5aRY8wFX4DwX0CXzusFVGMP8HDW
	 +w0jb/BoZEBKSpqHIwVtXQpghl2++WwDJKAvYfOm0f9aRHW1XmhwmnQGA0/sDkB1Fe
	 08k/RTa/oF8MP1apqx7WvhPeFDEuhG4WYqXj9FvDyAVv7wz4arsNJfUrbwvNkV2N53
	 ruq56b3aKlbkk/FJyufUj8YDX0/gCTnTYkb6fxhWe+jNbVpH5JL84bWawJ+EwzSEBh
	 0+sMa1n0ix4K3xzhNU/RFESpOU+ysaSngiZSOhhwTGFCTqVne1eqgJRWAisSPVoz4Q
	 IkPrLaVI+Y0XA==
Message-ID: <sashiko-outbox-212547@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] stddef: Add offsetofend() variant of
 struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261112-offsetof-v2-1-276ede839967@arm.com>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
 <20261112-offsetof-v2-1-276ede839967@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 09:31:25 +0000
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
- [Low] overflow: inaccurate kernel-doc Return comment for
  struct_offsetofend()
--

commit a83afd15b73f01058421922341af6cf7cf31d535
Author: Bence Csokas <bence.csokas@arm.com>

stddef: Add offsetofend() variant of struct_offset()

This commit adds the struct_offsetofend() macro to include/linux/overflow.h
to calculate offsetofend() on the type of a struct pointer.

> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index d0f04436343e5..060dad4b6f3e0 100644
> --- a/include/linux/overflow.h
> +++ b/include/linux/overflow.h
> @@ -464,6 +464,18 @@ static __always_inline size_t __must_check size_sub(=
size_t minuend, size_t subtr
>   */
>  #define struct_offset(p, member) (offsetof(typeof(*(p)), member))
> =20
> +/**
> + * struct_offsetofend() - Calculate the end of a member within a struct
> + * @p: Pointer to the struct
> + * @member: Name of the member to get the end offset of
> + *
> + * Calculates the offset of the end of a particular @member of the struc=
ture
> + * pointed to by @p.
> + *
> + * Return: number of bytes to the location of @member.
> + */
> +#define struct_offsetofend(p, member) (offsetofend(typeof(*(p)), member))

[Severity: Low]
This isn't a bug, but the Return description was copied from
struct_offset() and says "the location of @member" rather than the end of
@member.  Also, the commit message body refers to adding an "offsetof()
variant" instead of an offsetofend() variant, and the subject uses the
"stddef:" prefix for a change in include/linux/overflow.h.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112-offsetof-v=
2-0-276ede839967@arm.com?part=3D1
