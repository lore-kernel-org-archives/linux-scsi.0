Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795742074;
	b=VTHUumW9BGrs5VH2PkTIP8YSBZguimlYkJqFVs6yH7MUJcis4ownALryDt+etB7uNcpZ
	 5OKqA0RyuZQYAtuwQd8530hnwVZnwWfKDe2FjNuRNQAscTtu4f2sI4PghwCCUlVBp8MCV
	 XeLBTlWsv+BM4cXLLDCthiDqvt75vh1XftJEkEjiuSpds//yMy0mBAr0bKHOpuYHm4pR1
	 j26dhOVAKJ2DGeb+W4CbuC9MvwWtaq4iyBn50ZlN+j03wd2s7BIq1YUHTfVGQKbkLIiIn
	 2JwGOaRZphme29oM3rsZbWCQelfyIQYlhhOKSHtgviqBuqC5D1MmM7252c4R+C1d2bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795742074;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Content-Type:Date:
	 Message-ID;
	bh=4QuyiSQPiIDTfEJTEpYvEBkj4Se4WoY6XU6KWrukd4U=;
	b=x/F/Tb/x1WQW1ou8M6KdI1hyie2KMo4vkigAGA1bRUl2vk+nYcXVyl4b0xuFruugO1xj
	 0tkSZ0kABU3bUEBkri6U6bcjIVRzcYsdaH6nOnrsPKHDxdKLXWlgy+DNfDWC2d+pcJ6Aq
	 UwUtrQWUvjMScspzotZoSlqcKWFLaXmA3yjfqSqiEofyjXx4BcaSqSGg4mu9+S+jucfFj
	 W6tNp/3SdhU9dg2ByJ+PYIaD8HmnSCs8gMQois27HNDqcldWrK/UQ04OCy2DukZEOJomv
	 vDjf7wJByzVtjORjdtxwtyYgBXOvtR5nETBU3fRBePTGjOtphlDmzKrsnqJTU/CODHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmOzr30c;
	arc=none smtp.remote-ip=209.85.215.180
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D01E606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2026 01:14:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D01E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmOzr30c
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdab938dc83so2960645a12.3
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 17:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795742073; x=1796346873; darn=vger.kernel.org;
        h=message-id:date:content-type:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4QuyiSQPiIDTfEJTEpYvEBkj4Se4WoY6XU6KWrukd4U=;
        b=hmOzr30c+0qgpXbHWE5P4GmRbt5ZUi11M2NqCYYQLylThd5knPq6PJ6ogs3KT6vEF6
         JZX1M9FEsE6Q//IT9/vUUxgHLdm/tRsFFmGgCjhDErrqojsROvjBDfRKlG2bNr9yGf3D
         A5Le1zG0zhl/FfMkTR432M2U0kb8uR3p4vYjh1JJ8OV+p7EbAJR9zuOym0EdGHcyzjMy
         Cf0sKL16bmabvYS4p45bZ2Rub9ppW99S02ysbKY7tB/z6uy60sMC+Sw4qFhDjYTieMOk
         tBBPcZ/q+Bm2vRweffm2bNerpKs9TJJgurpFS6PT6Db9hrWCjb7Zd7V9QLxCaO9NIWIw
         igAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795742073; x=1796346873;
        h=message-id:date:content-type:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4QuyiSQPiIDTfEJTEpYvEBkj4Se4WoY6XU6KWrukd4U=;
        b=sbbhtjOqDx8MA6jmcPjz7mXPmwUCuftSXLRvUp9ikAUqFToJOlokqgND+RHHOQn9tP
         IegWwzn7YxI/NqTQm50VeLdNUYNv2BlLZQldK2tuzhVB9WkQjOej8AluM/2vWUkourhB
         zg25UQ5CnE0/Bfb8WLI6xG51lFK++cznMi5HKHyW6clKho6iLeC6JNBMXf/iHBgcuZFn
         GqPiPsQcRkLNwJim1NywUh3i7yFFa9L1TEcdcpPLfKeZ97n0JEfK+4JGXZvkq1K8tmu8
         b+1w5wU/gwt9vgeguynOZMJ9UefjnbSXtsc54oUBmL+mJxuhs1bKOsGdoUWyKvhsntcd
         1LNw==
X-Forwarded-Encrypted: i=1; AL+hErHjTql4FwnQCcJgGAgZhaTg9MZfXU1qzZCzbv7C9lXexgHjdVsb80LPox6Pk4CAR5uNOXdaaPxq9z3B@vger.kernel.org
X-Gm-Message-State: APuU4Z/bu6NB8sbGCNeskPkihG27yjD50Gkl+UU6Gnv04APou8YKdpOx
	IEcKrVwwAE7rIxQm08mwaGeQuu4dM8YWZGa8H3ZKaW6vP8afDoiGgj0I
X-Gm-Gg: AZFdTZfUzQE0YG+pqfoReOmI1qpXCPzA3IdFq6RkC/BlU96rHs2P7ELHpWkviiKUa6N
	+nZKXzcMHLXcAwFL3VxQynHptSoZ/IbE5AOaQY3XzsFneJsca1acDfPjjudv48P5aR2oB9kXpIM
	CStJEbRfM+FgWN8YmD46R8Ge6xZsbom4BmPEsK/+pj5kN8m+k+XLzAa40d8iIkUthmVNe7yvIYL
	Evv5OslTn2fhFIu6TVB9UPBkeiLkTT23j/CHgdPHLPSlBMQ7kbLYCgpufQN+Scz7KU/mQsOeBqH
	0+NMr7rGp0pfSpN8bz0lguhwEFYnBSK8DT7OosQNdksHFFJ03xzi+nGNj8zcbINw7FUsMZQvdkt
	Mc4rFG5tkBBEv4SYMF1r8E/iGx08DLQVKH7v0qFZKX2TSqnWERlqBxwuCNDbDwszU8+kodmMClm
	RN80cYmfqHisO2RO74rfrYLC3D2pG8rukCcBnKmFxVhTnluhf+mKn0jeDxdedisbiCUvNZHpwdN
	FD2rtSY/PjDiezgz0ipM2DijjhKl8bgegkovVrnVHWSd6/iQg63L4bxLkohX7Qspbqgcql8czD0
	fZctGzy+X6utQHJF7DlMkuijSQ7xh+7Hzhp4dDGGLSLRuBY5J74qB5KNtdf5AFn5iDoKDUVKLLa
	gZX6qWzU5Fgsuw+DR8kRd
X-Received: by 2002:a17:90b:1a90:b0:3b0:9941:8d42 with SMTP id 98e67ed59e1d1-3b41c92a1c0mr20960400a91.33.1795742073166;
        Thu, 26 Nov 2026 17:14:33 -0800 (PST)
Received: from mac.lan (114-45-165-38.dynamic-ip.hinet.net. [114.45.165.38])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b2c4sm35005235a91.4.2026.11.26.17.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 17:14:32 -0800 (PST)
From: Ilia Snezhkov <iasnezhkov@gmail.com>
To: Peter Wang <peter.wang@mediatek.com>
Cc: stanley.chu@mediatek.com, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, louisalexis.eyraud@collabora.com,
 linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: mediatek: round scalable clock bounds
 to clk_round_rate()
In-Reply-To: <00ba0aec941a72c8401eab7c3d4036caa2ae8aee.camel@mediatek.com>
References: <20261126031008.27506-1-iasnezhkov@gmail.com>
 <20261126031008.27506-4-iasnezhkov@gmail.com>
 <00ba0aec941a72c8401eab7c3d4036caa2ae8aee.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Nov 2026 09:14:28 +0800
Message-ID: <179574206826.56397.7920531590189565888@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Hi Peter,

It is not a missing hardware calibration — it comes directly from the
fractional-N PLL PCW quantization against the 26 MHz reference crystal
(clk26m).

On MT6789, msdcpll has pcwbits = 22 and pcwibits = 8 (14 fractional
bits, 2^14 = 16384), with VCO range 1500..3800 MHz, and ufs_sel_max_src
is msdcpll_d2 (msdcpll / 2). To target msdcpll = 384 MHz (msdcpll_d2 =
192 MHz) at postdiv = 4, VCO = 1536 MHz, so the required multiplier is:

  1536 / 26 = 768 / 13 = 59 + 1/13

Because 1/13 is a non-terminating binary fraction, no integer PCW value
can represent 384 MHz exactly in 14 fractional bits:

  pcw = 0xec4ec (967916) -> vco = 1535999512 Hz -> msdcpll = 383999878 Hz -> msdcpll_d2 = 191999939 Hz (-61 Hz)
  pcw = 0xec4ed (967917) -> vco = 1536001099 Hz -> msdcpll = 384000275 Hz -> msdcpll_d2 = 192000137 Hz (+137 Hz)

(With postdiv = 8, VCO = 3072 MHz = 26 MHz * (118 + 2/13), the closest
PCW values give 191999939 Hz and 192000038 Hz — still never exactly
192000000 Hz.)

So the CCF __mtk_pll_recalc_rate() / clk_round_rate() result for
msdcpll_d2 is deterministically 191999939 Hz, which never matches a
nominal 192000000 Hz entry in freq-table-hz under ufshcd_devfreq_target()'s
exact `freq == clki->max_freq` check.

Best regards,
Ilia
