Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795741847;
	b=YYESt2IFPpGZKbXkj5OiWE9mSoxLbDv2CGvcDYCDRQJZ0kQDWoOT6eGIGMw4xrGBDVgW
	 gV9rxhxUQptadQspWsyNsDIdYSCGaFsnHaXOrnjNHA/+CEsJommuHUoDIiTTtYNhNCLsR
	 1bnFX2t4PJW/LqXh7LzzBLwR62RJERKov2EwqjDbt86yiqI+spCaxN/cIDBY3JA9h7x/E
	 XV+fVK5R87TvZ4Q/cJ5VjA8O4yj2MrtmMhe5ZIOyXUy2Boa4FRhC910WcyszwAJyItYL0
	 VrWkwup8pTFaSFUQ9i0IqJz3No+gVunASByBKTFfOwv7vYc9KNYksZBtfrQ9VrgXgOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795741847;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Content-Type:Date:
	 Message-ID;
	bh=HZ2sCqXwwWM570Uzj7/jKB0ciamWJ56LEpgiUf6Er7s=;
	b=E8ym95kngwDHLNQUGQatgY9tCi+U7/H2QhnbREu6+5I5H8sgv5dRX3Frb92gOf/FU7b3
	 7jeKxr41JSdeTXE1SajMukhHLCF9fLuJOkMRHWtaPdWW48W7E1b575arS4iMnuM/IDEUG
	 un7w8KJBT5IYegmhNhCja743MuPRwjGEvpdHnkWbbVah0T+H0DJ2yIFo8jWnYv4Zln4C7
	 Bc2Bu02pb4zh0fMK1/4MxXdBmxg4f/vlcDq1Bwzphuf7wM5okkloU3NiiLWM4+3/OTwBr
	 9B+EqKxximHre2aN03od19nkHQLIkTsf+CT3cWStPqZXKPz2c3g9aedm1zPADtdGcmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K7wpUDC6;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD8606A31E
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 01:10:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBAD8606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K7wpUDC6
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f0918f9e6cso21732775ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 17:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795741846; x=1796346646; darn=vger.kernel.org;
        h=message-id:date:content-type:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HZ2sCqXwwWM570Uzj7/jKB0ciamWJ56LEpgiUf6Er7s=;
        b=K7wpUDC6Gq3dN0zmS6NnEmNqGUhHVyKQaTAo9TXsuZhUOJtuilvLBW2keTkjDTuOxW
         8CWJu5chybB5QWUU0d/o2obVqm3bK4T1Xxl0f+FishKYTxDzac1DLdmNW+MBmjP3Ux7F
         mXM0DQCzLeGrhYoxSCIhmk98KwdqJJEft7Jt0KK/+1lgHDlYpqbRrxfDSiTTsGDvDTqX
         xHcbHwTPOyArmWHfTxJX+C/VvsxNvs8D1/n0DwlzkA6v5EGT6MYmz6PnBMO+S2Hwjo8d
         qpc/g0Ek3VnXzAayMR7TVQknTmVWSfxKeNHI69VLwv3SfKz3zMv+Cq8kCyfn/NOyhaBU
         ALtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795741846; x=1796346646;
        h=message-id:date:content-type:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HZ2sCqXwwWM570Uzj7/jKB0ciamWJ56LEpgiUf6Er7s=;
        b=fKglwgRAXqImh/Derh6YiE1aaFzMzPiSBFMsYDK5RWTVxXuo/DTwwcfRO138PGqWSq
         cAMV5TqY5icfa/l/NF9ybc4Ob/WpDpTHPO1iuo/GiXu4crIIwkbb64DweN0IM+WX0WtK
         My4UD528iingWmKr6RIpM9tV9h3UO+SOXpr8TeIJI9XKKrmGdDaEI/cnnsUN62KK/dlL
         mbd/lZfwr2gCDbhUvZIWIeKCittDfqgnfcYBR0DrovISaJBC5jE9w9UxwIFLJOc20peE
         vxS8+ERZAPjcNSuGxGPBW5I/2Hezf9xvTHZfl5ci3sIKYGLAWUFWfLpgU1GKogZ3dNCc
         NarQ==
X-Forwarded-Encrypted: i=1; AL+hErHTbdfrXJ3LZgIfYoimULrpmnwES97abyIX8+Wwy/iplHDUieY/oNYcULi/nQn7mzpGROxHHDEd6QOb@vger.kernel.org
X-Gm-Message-State: APuU4Z+GxKaqB3SXyP4tMAq3GAABTGhWhoCDEcyzB6fO14lQhJh0N9Sf
	iHINotQ/k2JMfrt6GDJXgQgF5mPfEZ/ly58blKXMPQHmQDGQnM3Oycdf
X-Gm-Gg: AZFdTZfxWfQs6xi1MYHn+XXJOC5/8Tn6Z/B7QFLG7xBhvDgzr24QYDrV5pPOqXguMZs
	2kzpPmO99YRk5WWD/Yim0PJ2dXdu103UFSOKxX0VJ+FQ9iTSGN6r8ALi5VtQEv5x/DSR8nOJHYK
	GOaSa2GzbaL8AbbgePg+YhA5b9CXlGG0OZckCt30JPGcyLlFI2dQxTbslRIwcwIbvChsQWBbE+t
	mqD9SILmzbjJA0OIgjzahwf3xBLfEyvuKmu341IAi+2FX1IH6fnhbPPSFEcImlELD11o1KV6N9s
	+GhQMspel/ZeBGkR9bysjaCbzO8D61uqGkeQ9ybENIww5LAKp9sy/AMoKAepCE+e3zlO/+xOnF7
	3jN3vOifyFLpLWELBlUHE5ojn5uX/k6jVCCeQrr5AQUQDft+Ifp5BzVoLa/u/SNalkjTFAzU+Rr
	CnNWVj3ECOxculJe31zn8nPk5vnDXVdvucF/urJ+2+DMXXaSH+pQh8LWQqXv2IVsk1MxamdI0Ln
	2WlTTTNmwr1igoFOPzXMm1H2xlz+JH2/ZGNAMzTl1ZWN6Qv3o5v+zy115J13tOhPB42NpQEIZZQ
	XJFsAjqxdXhUQ9Yb48WPLjQNgiiGYkBTq2NNVljsKRyndwtFByf6VONDphVmvzE1rFav32PB7dr
	9
X-Received: by 2002:a17:903:19e7:b0:2e9:9a19:c54 with SMTP id d9443c01a7336-2f03f24206fmr190172495ad.50.1795741846137;
        Thu, 26 Nov 2026 17:10:46 -0800 (PST)
Received: from mac.lan (114-45-165-38.dynamic-ip.hinet.net. [114.45.165.38])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f1207f1sm110189725ad.64.2026.11.26.17.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 17:10:45 -0800 (PST)
From: Ilia Snezhkov <iasnezhkov@gmail.com>
To: Peter Wang <peter.wang@mediatek.com>
Cc: stanley.chu@mediatek.com, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, louisalexis.eyraud@collabora.com,
 linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] scsi: ufs: mediatek: allow clock scaling when
 ufs_fde is absent
In-Reply-To: <7b7d94ab4283b82aec13eae3f9c1d2e77873d88f.camel@mediatek.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
 <20261126031008.27506-3-iasnezhkov@gmail.com>
 <7b7d94ab4283b82aec13eae3f9c1d2e77873d88f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Nov 2026 09:10:41 +0800
Message-ID: <179574184161.52486.4990124402659702610@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Hi Peter,

No — this patch does not change whether UFSHCD_CAP_CLK_SCALING is
enabled.

ufs_mtk_is_clk_scale_ready() only checks ufs_sel, ufs_sel_max_src, and
ufs_sel_min_src, so on any platform (including MT6789) whose DT
provides those three clocks, UFSHCD_CAP_CLK_SCALING is already enabled
today and devfreq already runs. Platforms that omit ufs_sel_{min,max}_src
still have UFSHCD_CAP_CLK_SCALING cleared as before.

What was broken without this patch is that when a DT provides ufs_sel
and its min/max sources without ufs_fde, _ufs_mtk_clk_scale() returned
early on `!fde_clki`, so ufs_sel never actually switched parents while
ufshcd still treated the scaling transition as successful and updated
clki->curr_freq.

With this change, MT6789's already-enabled clock scaling actually
switches ufs_sel between 26 MHz (tck_26m_mx9) and 192 MHz (msdcpll_d2)
as intended.

Best regards,
Ilia
