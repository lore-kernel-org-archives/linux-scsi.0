Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795422078;
	b=TE2B0nRRp+SxYveaLXCNQqmMiw+1z9x0wNNdJkV4yPBR4lmmanNA3NFIB5KaB1L5AFT+
	 yzW5tM4EYogYLlH/kYaR9pDjcIaBrfHAQrwH8oeYT6ygMd4HG3MCIGfF+EdPlWMancKJi
	 t52D6i0x26DIQAR8KivpQMUba7dz4ul8bCw4aLl8pa5dUZeMbxVbT3onEHE5QmKrwr7TW
	 Xj5hSgPiaarubiwEcR4LGSdUeg5oyASiAAFmN1xgb4Psef4ffnMBEdO501X4BRQaKJacX
	 dl2rqvghlkfW4RTYrmCekDbEkoYjg/4bFV1Tev4yXW442l8UF9weqJ2wXT6UMCbwxTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795422078;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=urV9PEPwEvrHK4qayGYwaVV8yhJ/QEoLReqAK4fiRYQ=;
	b=EKIf7DQTdKXPgWjj/QPvTmYyegIbGhkuCyfVl/tYlnrbiqL8kvoHfaJcYPA3Xske4TQM
	 GNTTOJel0XV3EOThQQLs6zNnAtvVMmNFESQFCoSAnCa8XVVtnQg2ktmhlDyGxUKraLIsd
	 ki/n3UC2Xk+UEBWuD2uEuKJqJG6aszExbc1jcHDt8E6RfVUJwSIY04F/IPQNSA6WTUrXM
	 Y3mkkK5eNrPn7caSwGHEWjOzEoekjQMr5Nti0Dqk2az+MEzVFmB4VRBjLQ6MSx6VSkqFq
	 yaIAs7PGT6aYhyIcEqijETUV5d/qEaGGnZLjv/gHxvnfslqawEoFRF63VGnQlj/DuTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04F0606A321
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 08:21:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E04F0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7d2da1667b2so1913834137.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 00:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795422077; x=1796026877;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=urV9PEPwEvrHK4qayGYwaVV8yhJ/QEoLReqAK4fiRYQ=;
        b=tEgBJNqh16eE6oK1anfE2VQ/KhSMtUVHfUedRoJrNNdsBa92KIHWAnMdlTXhfLA4yw
         U/s/thF9YlmLkyGnggvxMo3unp6T6PdCIgpzuyRPmTjmktk8vHI5VmhiSfDf2uMLtcub
         +pZHxR6i+WQw0P1/XGWuDgdfA21vpsz656PNuyajWpaYVt25ISnQNlvqYze4/qAedYnN
         m5Z/iNlueO6HLXIwSSm8N5SQruF2YylvHfmPRuDE3uK9u9hSvw3zFgFCrqbiHBkyoF3E
         Tj0yVi5Vodx2NHjH0tofQpzFaobENOHFm+Se/kuHENcI91RlsryVEr27AVqFjnWEnNtw
         bfSQ==
X-Forwarded-Encrypted: i=1; AL+hErG+mng7qIMmtrjfZgicn3j3ulQd9XTU+nIb9SrDRWBP6lezwLhmaIuGMTEMpRq9c4KaP5cyD3ohaKjr@vger.kernel.org
X-Gm-Message-State: APuU4Z/sfu0h+yJGcMQdNNh3WHHejPOEvTdTNEQehHk+uelUi0MuvDDU
	lrugZTsbYKFRsa6VSP3cbUAJpXNNvCREG9+8lcZkNybQVbyRD5sqPP1vQSMPX505
X-Gm-Gg: AZFdTZeceN/vqWFRXmpGFesvtmi/iGkhgNOXkG+QJ3DpvFvft0CiyImKExtygib0F+b
	H7p9MR1TRoSa4P4wHigm9viGKCVG8vMTDWTfLKKz0pqXUv69C1rvGwfKOlxvVSsRpA5uKtVeN8+
	2LPsZW9yjS2OdIsONpis+6Olb71SRH92m274/3DNF158EFEPXO7ANNGoAPj2fcz0NZmNFVyPBuG
	lnLJHEsZb+Z5wGOSlNucRf4qunOfdG2Q6S746Hqb3jPsfqGNYoaWrv0hmnZJHQ6EK4bQqfTkUYI
	TaGMvi7xqYe1yILIden3kgGIxOlyX4R9SHIEUDCxWv/P3gFv0+Ixnty6qkL1QR208+KV+pX3Btz
	8pv6kg8LbOyJFqjpPNjYeIYGNuggttzHfpcauUjHIwRGMgrneAgxVfCjhAMWD5evbP3eEG/AZAg
	LcjmdqQG0jESIPoorw6k9S0jmh19IAqpKHWYagZxbVh1RxPh2ZHSqS9DEA0csF3tNLAepDyM9gv
	oTVI4ESJB/cu55r5NBHo6AcNezs583hIe9dgMOAehpbSTxOCFR3EoNs8EfT6AzQkFZxl/7+XSoj
	oqzb+Y++8VkfjQGKMDJ5nBqRFM5Rf/xVzUcv0IeHbvB9BTglRnwgIq0OJW/cI6TqdbHh
X-Received: by 2002:a05:6102:f11:b0:7d0:6cf3:d8f0 with SMTP id ada2fe7eead31-7d7393ff876mr5422372137.18.1795422076803;
        Mon, 23 Nov 2026 00:21:16 -0800 (PST)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99e6dd9fe41sm11356319241.0.2026.11.23.00.21.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 00:21:16 -0800 (PST)
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7d2da1667b2so1913818137.2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 00:21:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEmOW45uGoTRtit+5dN2LzTBFObJ52bf0RukJP3C6r3/iVf7pFnZy8X1sJ8HbVC4CgzLPxWwJ80rhU+@vger.kernel.org
X-Received: by 2002:a05:6102:84cc:20b0:7d8:869e:8e54 with SMTP id
 ada2fe7eead31-7d8869e8ec4mr1539357137.7.1795422075752; Mon, 23 Nov 2026
 00:21:15 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122160447.519889-1-zihengw03@163.com>
In-Reply-To: <20261122160447.519889-1-zihengw03@163.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 23 Nov 2026 09:21:04 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWxC7LNy3MTNYE62AoWBB6sHm9jKAsYKRjrZ+LfHjArtQ@mail.gmail.com>
X-Gm-Features: Aa3M54oDJAacN4ZgRznlESFwii2fz_UdwV-FQBJ6wD20kL1ynEn2pjnzqtgO3U0
Message-ID: <CAMuHMdWxC7LNy3MTNYE62AoWBB6sHm9jKAsYKRjrZ+LfHjArtQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: 53c700: fix invalid frees in m68k driver remove paths
To: Ziheng Wei <zihengw03@163.com>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Kars de Jong <jongk@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"

CC Kars

On Sun, 22 Nov 2026 at 17:05, Ziheng Wei <zihengw03@163.com> wrote:
> NCR_700_detect() stores the allocated host parameters in
> host->hostdata[0]. The m68k remove paths instead use shost_priv(host),
> which returns the address of the pointer slot and causes an interior free.
>
> Free the pointer stored in host->hostdata[0], as the other 53c700 drivers
> do.
>
> Found by LLM-assisted static analysis. Cross-compiled for m68k; no
> runtime test on the affected hardware.
>
> Fixes: a16efc1cbf0a ("[SCSI] 53c700: Amiga 4000T NCR53c710 SCSI")
> Fixes: 8276b58af4dd ("[SCSI] 53c700: m68k BVME6000 NCR53C710 SCSI")
> Fixes: 506c7bbcd9bc ("[SCSI] 53c700: m68k MVME16x NCR53C710 SCSI")
> Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziheng Wei <zihengw03@163.com>

LGTM, so
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
