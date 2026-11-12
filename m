Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794480473;
	b=zUmpa+z1DMZiWVvj8MXVBeEZaYDN46WF+Iev8PT1tdI8Bnu0oIXlv9tlPhSC4lGlC9zZ
	 tl2b1rRe8Srdn63B9FGcuDqaiAPI/Wr1X9hSb0naJeXEh92wCy00ceW6oKUr8cV5yo0EE
	 H+gHO2H0lhvDgEb+DzhY0r+Dk0AkH5Q2+RuA/+Tl3jj7l0vbGSK1kPFnma3ihxtQWVwoq
	 Y8ffu8XTpVsflWY9xfU4bm3o+tcXQmSOWej1w5aIVUo37rqgNY2auR2/HcRh8ncYiIEUY
	 AtBmJOi6l/cg9AzDWCXNR4KJtHBpd2KQu+TxrHPVV+btO6rAm55EUXuW4EpjopiMlyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794480473;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LaAKKhAngwkFxDGEu7glsCDhQDKP6or5IXQD5q9C6lk=;
	b=OFcbvIjbOzHGNtCHG4HXx0ddP1wgbt/3Y/+r4tWI7i36QpRA3TGP0QsB2bseewFlcLCS
	 8I4tTQUplDSzJVrhdpMpR0IPnJtPlzQeXnXCJHIuJdi76Lsr5SF1+BD+TFKCEaPbbO/s6
	 5RrHs6wJ+YP4kvKLu1McTyGz84P2VIYLHaSHB0/Jvz52Lmq3vffGz/sCSYW9ThnJAB2uW
	 wLDOrhRz5qCp/OgUEPfDJD+H/xDPh2Fyy0xck4E6UXLMLJnSFGtJH9n25BHQRvUXCdzYu
	 /2xSs4cwMFQuddCM4BELRVLokR3ISqVgFmbrCOJfCSf3kiFteblPsdztAfgfHSwhG4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bhRW52/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CF606A32D;
	Thu, 12 Nov 2026 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhRW52/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85FD1F00A05;
	Thu, 12 Nov 2026 10:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794480472;
	bh=LaAKKhAngwkFxDGEu7glsCDhQDKP6or5IXQD5q9C6lk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bhRW52/OaiERqOjVo+YsX7WenTAM+RkUSYdDbFFgDeELIFl5MCvdrQ4/lrfg3PaBP
	 OJEvlXHrGI0KP6Sf7isOdA90CQUC1tSnbnlL7KMlGmOGy1uOT4Tps4k2NALfzc5lt4
	 GBKdaLdl6Hn4QG7D1jOt3xg+R2SbDhwXqrQ5QTOpBVzV6PCDTf9sB1jcXxmSVYEwEX
	 9k1ve7B7mHoKt9f85FezBUXVhvbLCq9DZT0dTEHtWXQsiFKFjjwdYqhwDGS2C9B8hk
	 PMIxYSXrd0qwW336ZZGtXr/22P+Xd17f+e0rYlMLg9nZUtItJXlZjgdtGYx+r60Y9l
	 +6iWNMqoSTUaQ==
Date: Thu, 12 Nov 2026 11:47:38 +0100
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Bence Csokas <bence.csokas@arm.com>
Cc: Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Cristian Marussi <cristian.marussi@arm.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Selvin Xavier <selvin.xavier@broadcom.com>, 
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Chengchang Tang <tangchengchang@huawei.com>, 
	Junxian Huang <huangjunxian6@hisilicon.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Benson Leung <bleung@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Guenter Roeck <groeck@chromium.org>, 
	Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	chrome-platform@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] stddef: Add offsetofend() variant of
 struct_offset()
Message-ID: <avWY8kNFlkLyxIrX@devuan>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
 <20261112-offsetof-v2-1-276ede839967@arm.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hmbonzz4lyxux25l"
Content-Disposition: inline
In-Reply-To: <20261112-offsetof-v2-1-276ede839967@arm.com>


--hmbonzz4lyxux25l
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Bence Csokas <bence.csokas@arm.com>
Cc: Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Philipp Stanner <phasta@kernel.org>, 
	Sudeep Holla <sudeep.holla@kernel.org>, Cristian Marussi <cristian.marussi@arm.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lyude Paul <lyude@redhat.com>, 
	Danilo Krummrich <dakr@kernel.org>, Zack Rusin <zack.rusin@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Selvin Xavier <selvin.xavier@broadcom.com>, 
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Chengchang Tang <tangchengchang@huawei.com>, 
	Junxian Huang <huangjunxian6@hisilicon.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Hans de Goede <hansg@kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Benson Leung <bleung@chromium.org>, 
	Tzung-Bi Shih <tzungbi@kernel.org>, Guenter Roeck <groeck@chromium.org>, 
	Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	arm-scmi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, 
	chrome-platform@lists.linux.dev, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] stddef: Add offsetofend() variant of
 struct_offset()
Message-ID: <avWY8kNFlkLyxIrX@devuan>
References: <20261112-offsetof-v2-0-276ede839967@arm.com>
 <20261112-offsetof-v2-1-276ede839967@arm.com>
MIME-Version: 1.0
In-Reply-To: <20261112-offsetof-v2-1-276ede839967@arm.com>

Hi Bence,

> Date: 2026-11-12 10:29:33+0100
> From: Bence Csokas <bence.csokas@arm.com>
>
> Many call sites of offsetofend() use it for the purpose of pointer
> artihmetic. Thus, a common usage pattern is:
>=20
>   offsetofend(typeof(*ptr), member)
>=20
> Capturing this in one macro helps keep lines short and terse, while
> still making the purpose clear. It also helps discourage spelling out
> the type name on every callsite, leading to more maintainable code.
>=20
> A similar struct_offset() macro already exists, so add an offsetof()
> variant in the same spirit.
>=20
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>
> ---
>  include/linux/overflow.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index d0f04436343e..060dad4b6f3e 100644
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

The outer parentheses are unnecessary (they are unnecessary in
struct_offset() too, but that already exists).


Have a lovely day!
Alex

> +
>  /**
>   * __DEFINE_FLEX() - helper macro for DEFINE_FLEX() family.
>   * Enables caller macro to pass arbitrary trailing expressions
>=20
> --=20
> 2.56.1
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--hmbonzz4lyxux25l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmr1mUAACgkQ64mZXMKQ
wqniCg//WgRXXz7luTnHUaMXrHNthttFpY3wBO557jzGIfLwMa+0tJqYgSh8MGS8
7F44pQ7lX8E0qC+aMkDd3ItqdrKeD3McIbqqgpr8iU1VT0ljohr8pnTU7UIyIP/u
bX/o22pWYohJFt/xcJcLxQ63rHmjcfjH2ug2i8ZgZHh/YGX+Biah79nfkcAB+uYX
NI+43mSTP1aHvUK3Jf/z7PJF/v1/vyv1zJ/nsoN74w3JhlYGMggMcXHSu+dp0jmX
qJUkyYJ5SQEzMdU/n2pSgOJFIZl6YS957I6fhU3GxEPXSldcnd/VIH/QRKMpSyjM
jWzBsyjyyink+9RSw7AcmU46DJ28GeWMW5jZdg7jXq6ZGjO0/AKleOtMrevQLN4s
hB7CzUrtofXBv5Oa5javphhfKIEoawgDsDch5eXFQW/Rm9rSflWysbPTCST5n/h0
GfKbUEzD+COFj6I+Y8COEceKp4Xv8Y08A3r6CyyNIPzPwcc0CulK6xAmHbsMxIXZ
c6uz3LLfqukMfbuquIZE4KhlNt+ZLRtnxL6rFfFkvLYdz4KwIsljmiPqoyPQxp9A
OX5vOdZ9ulzmuuNoTY5OeJWSlsI6edzNc17hE6jjR1+wFfJSzVF2cvvv6mRGnpY/
bGpmsQZFuH/KWJutZlHbsMGYEKF7lo42UH0Tqx57oaglMss89x4=
=8quq
-----END PGP SIGNATURE-----

--hmbonzz4lyxux25l--
