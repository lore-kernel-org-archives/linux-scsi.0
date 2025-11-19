Received: from mail.novencio.pl (mail.novencio.pl [162.19.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBBF32F76E
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.19.155.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763542895; cv=none; b=R0ck2BBqlas7BYDbDFBJLIxhhe1GRId6cjZ9gCWGhrztFdvrZEEKu9KAdeef3Z42p9QqOBN4FX0UHP6JgPsAFwbLpQ4OsMJgu9y3AVUHYQSXBZMWRoUXT93VEhT1Hm9ZmWDuOM09moDcm5a9rC6ZWxbhy94cqBOafYrDUKBX1pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763542895; c=relaxed/simple;
	bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=ESexeC754WaKV6jCsuG5Pwjg4n39Qn24t9bYAHyG373zr+gPz7ikypIJ3BZzL3W6K1UZn/e4t8+ZsnHzEOHj7UOnGgH1lMxiipUmDPf4CbHa5giV92YEsx6gD378l+m/MVdfYOB57xOeGaFJmovP5HyUXyRMXTjNpNbrOmanZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=novencio.pl; spf=pass smtp.mailfrom=novencio.pl; dkim=pass (2048-bit key) header.d=novencio.pl header.i=@novencio.pl header.b=jrkVh3J3; arc=none smtp.client-ip=162.19.155.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=novencio.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=novencio.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=novencio.pl header.i=@novencio.pl header.b="jrkVh3J3"
Received: by mail.novencio.pl (Postfix, from userid 1002)
	id 0056424E40; Wed, 19 Nov 2025 09:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novencio.pl; s=mail;
	t=1763542890; bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Date:From:To:Subject:From;
	b=jrkVh3J3va9rQ8+qBcpzqzjvLL41oYu7JwdgnurHDyKxqYkxUCNLRZTqFUUdCSN1k
	 yX1ggyt8HJwKTnuset+0tLKcD7Ag/m9EHvoDau18fw6PjGyNh5iTJklzF0ViZYjPzH
	 JsHBgTei5kC98OFJyiiGFpzDHlcqY32z+cNz0cMsXrEaVBzOPc0+XRHdJcqByTJ+33
	 nBCheWVdCrqlr8nbAYeG46N9tU6HMgNRf35xheinyzLaGLD0d5DukkgEXhjXqkD0EB
	 UeQ3xDZgybUbmSId+jHVaWh4hAzTO+0+ri61D4M67cAOZsXv5bl5rQbt0UNVXmT42n
	 R22WUMdDztN6w==
Received: by mail.novencio.pl for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2025 09:01:03 GMT
Message-ID: <20251119074742-0.1.5y.z40a.0.zeidn4aomo@novencio.pl>
Date: Wed, 19 Nov 2025 09:01:03 GMT
From: "Marek Poradecki" <marek.poradecki@novencio.pl>
To: <linux-scsi@vger.kernel.org>
Subject: =?UTF-8?Q?Wiadomo=C5=9B=C4=87_z_ksi=C4=99gowo=C5=9Bci?=
X-Mailer: mail.novencio.pl
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

pomagamy przedsi=C4=99biorcom wprowadzi=C4=87 model wymiany walut, kt=C3=B3=
ry minimalizuje wahania koszt=C3=B3w przy rozliczeniach mi=C4=99dzynarodo=
wych.

Kiedyv mo=C5=BCemy um=C3=B3wi=C4=87 si=C4=99 na 15-minutow=C4=85 rozmow=C4=
=99, aby zaprezentowa=C4=87, jak taki model m=C3=B3g=C5=82by dzia=C5=82a=C4=
=87 w Pa=C5=84stwa firmie - z gwarancj=C4=85 indywidualnych kurs=C3=B3w i=
 pe=C5=82nym uproszczeniem p=C5=82atno=C5=9Bci? Prosz=C4=99 o propozycj=C4=
=99 dogodnego terminu.


Pozdrawiam
Marek Poradecki
