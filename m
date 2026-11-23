Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427296;
	b=Hi8EQoicFXoAhugaPoPeVZYCwiNMWpyXyOQXYKJ3GJ7hjbubCR5KNjsFpHvpmv9k+/1C
	 ARCwke281PC++e1R4XEoKWcA7i64G8NgYHoREkD1xvUgN+PVPpHJ1P6BlnmQgyVI+BsrM
	 tRXWZP1dGxiid6mMuVdBSPWCPrUzAW+U8Uqp5lTP82f0tF+iILKyTDlF5gtr4DYGHE6Lj
	 tiJ3zoPVuU5p8nN2Tvn6xW7q6ZT+1iQguBNgzB9ZgKQO6dMirpU8pOzLC1z7Ehk9h8xzq
	 vPu4gqSkgfg1Zzlj9ddRHps3lN2S6NdhQIhU+pVRpf/BzSOW+2zXicYmg9hy/TuVv+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427296;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=cWZpBhDqNHZ7OOEEIRJTwjTd8bE65OY0/Xt9j7AHp2c=;
	b=RhoXk963T44+VpPtGe+4y3NbQNIGsAuG2h9MQ+CiB0nsXSxwGvUEf2iI2RYM1TSMuhP2
	 glPs0TtLSEjHdmwsGAPY16iQUCOgqqmLSxUGb8zRpC7YZbzOHJWwEVlDP/8IqNqieJtx1
	 lefHu3pKIDfeopdDXohheMu6rsV2GDdAyeYkpgo1e9E/CDCPPgh0p+0wVdLwY5nMsW+74
	 RraEAeaUxmTigRx6UgMZfoUHr0pML9oM0nyHrFfYrg1vEENB6AGml22aROj6C3PZ39Xbm
	 eK1MOzLDOgGd5gJlfLWgZ2MhGYBpAvBM9AwNEvA+j6bxHHyikQ30HXSQefhjNrP7txA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5C8606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 09:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A5C8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7cc2bb73cd9so1090022137.3
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 01:48:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795427294; x=1796032094;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cWZpBhDqNHZ7OOEEIRJTwjTd8bE65OY0/Xt9j7AHp2c=;
        b=0wO0d2z7zQNXsEX0+wJ3vKz5n7YOH3Cd6VCO+FIkTa2FKF5qUrmJPk2GsaD4RqneCV
         mQlcshPEMc8nrL81oFrUFzAGXQpyK/pP/DViQ+O+94ad0dZYnI+VgExXXay3eCtyVLIV
         7acw0mgyT+2xbDAXkXTDmfgyvXkZbQ+OLLJpUGVNZVTc9748HCWsAhpg9IGjU7x2E1CK
         nmeNOjFdGNZ7nd0deI6AVTAlOpsw6KNP68FoSwBnM7VSmRPtyHu4Hwum1ee2ksldQHar
         RX2jM7N0eI6C36ktuxZBlqJOaujXUtD8wAJMwQ3llKzgtqS2qF7AQ/oqMSaW3F+6CNqM
         Szfw==
X-Forwarded-Encrypted: i=1; AL+hErGwLcIqoSXInKeOzlcu0QAs0ENPOH9ipQKl9KNazmu+K6bbREruvrrvyXJ14GqsZMdRU9ZDy2UZqgh5@vger.kernel.org
X-Gm-Message-State: APuU4Z+GvgLy6xDEun8IQi8GRji5EtoIrpdDWTsLjyjKR69gBBinyX8j
	6zSe1t8ktaDdIrnTNiEJUiohmpGCDR7ja5k0E9yZKoH7Q9I/bCMsv2F5EXEhW7SL
X-Gm-Gg: AZFdTZd9ji4kxR5bXdeqYcLwMlZ/6UXr+TYr1rW1DsOYVdJiOh9PcAgInU2gXCY2i4m
	3yeLCMeiqHdyl8dfR9Wq0igzLGFKhsrTMXy7MmHhWqk6A8M6lu6TATiT0+WrxjQ7Csv/Z7eeH1V
	fMZhDKoQuZibQUmgZFJxcspr/XQ3Prp+QUwk7cD7LHQ6lqBNuEJLaT/ySgqgDj8GI/CelR5RiMF
	yox4VxTWP7ujey18fHCESESA0kzrdHGBfjjrvQDU8QYJsR3WycZLDfZ+MS4H3mEg/9/n6/FPuEs
	aOVqo3G2MiMOE05VbPvolza7b4han8RBP8RRFqPGXg3eM+8k6i9lpTsGr8jdPKqBnzr0bpCImXu
	Z+EqQb22iT0az+df5BrN40T9vvG7GN6UdTaqTvHWhnttg4rkJlekB9cQJNvIpZ5yMNjEKi9S0Ka
	Sq8W+DWC3rRIMWpo5EnPm3ekebj00q2ZFwF1CejhOhDXUhT6X4o46+La4xZGl8+0p/WtqAQFviq
	xEKe8PNJLcjuc7ogGafiEIV/SqNoc4vVKEE0kUV4gf8+8uzSxUu6QTnkcUYLIPhex5mNvw36Tvc
	2xRj/+oP/CqL8CHlGZPTrjXCtPizWRuRGddg2vVF4kCEprHn52NYhdnZGaXa6X93U2A=
X-Received: by 2002:a05:6102:4490:b0:7d2:7be1:272b with SMTP id ada2fe7eead31-7d739625bb4mr3909918137.28.1795427294446;
        Mon, 23 Nov 2026 01:48:14 -0800 (PST)
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com. [209.85.222.43])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d6e8219b2esm11161613137.9.2026.11.23.01.48.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 01:48:13 -0800 (PST)
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-9907a58f14dso698172241.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 01:48:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGl7Xe9LnaqYiuVVlXfXWqkuG5NCwVPnXtL9Id/itZRFqXSFz07TWa9T1bj9FriYLj2gHOBmNDRHJko@vger.kernel.org
X-Received: by 2002:a05:6102:5813:b0:7b2:508e:3d57 with SMTP id
 ada2fe7eead31-7d72b3688c2mr4372703137.4.1795427293752; Mon, 23 Nov 2026
 01:48:13 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
In-Reply-To: <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Nov 2026 10:48:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
X-Gm-Features: Aa3M54rqU2bNqHYEoVpo9DgHQN7kUDp7nLSe10xRxRC_Yz7fZEF6xyok7yTvw-g
Message-ID: <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
To: Finn Thain <fthain@linux-m68k.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>, 
	James Bottomley <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Finn,

CC scsi

On Sat, 21 Nov 2026 at 05:10, Finn Thain <fthain@linux-m68k.org> wrote:
> On Sat, 21 Nov 2026, kernel test robot wrote:
> > FYI, the error/warning still remains.
>
> That's because the qla2xxx maintainers at Marvell did not respond to any
> of the three fixes I sent. I'm not a paying customer so all bets are off.

That's "[PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion",
first submittted in March, right?
https://lore.kernel.org/all/4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
