Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794371036;
	b=Q8ObL53GhDjK/JQp2gCg7RDP9edD0gzekvL3wx9fUZ/kWJULZHNJ4LYo7O+y12AJXS2s
	 5kCvdEaEdrSYPwoVfwUFMhgmEo9ufi3IpNFlJvh9Sj1zk6xNYZRp4AEGxVqXi8HAwPyON
	 ZVD7KI6uMZLRYm1+TejX+r09lugDqUxHb4DEl52Tty6f3fsSjxDkoDJIq246P524+w9iB
	 Z+n+moi38YCFuPa+Sr2uKcRXjBlOuKWj1f3imn5NCRH28Kf3LybInvQurE0ix1n539WG0
	 FuD44UeOl1YbnOBJ9M8/M39W03fh3my1N10+LLMMpG2pbU4gH2b+WBcz9kuo30Pyn7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794371036;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=3/oMUvfjnRDqTYECREY0yvKf+oNzhYCqjwUaHTL4kiI=;
	b=yQkLBu4MSVhVteKMXp1DR25j974d9unCAlVNrljzNCXZuftKdprHUI2OUakwo4Fc9h8u
	 hTCSfMP3H8DBAseDxe2t1zet653ctkJEtQrJicFu4X+1MhYrODihTuFXxMxUgBmMQFRme
	 q989gLr6FUphBDfZfNpRSRPOk5QlPPe0O0Y92VWEKTDRo+HXCMtV3yr+GBFzDWmdTP7bo
	 9I8HHLRtkQl+jVh/X6dQdjOQnzXv6Mpp0Jc/Vo4IKxfyelczSLKqfVfokgxKum97S8wed
	 3ZfhbGRSuUHj47yOnL9HiMsiqugGF/ljaAPPEu6bKtG/XgFiZD0HLCLc+KrrKtPuOMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=andrewgigena.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7B1606A324
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 04:23:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D7B1606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=andrewgigena.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b37c7d767aso21872557b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 20:23:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371035; x=1794975835;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3/oMUvfjnRDqTYECREY0yvKf+oNzhYCqjwUaHTL4kiI=;
        b=y8383Uw6MCOYZTsgm/H8+22ARLB6QMqmyyOie9nYEc1hzTVNKb0h8U1oF0HwMH7Igi
         jmytJq2I+Nhi8LpHNSxyz5TIq9fKokI+yvewVzvwgqUAI1E2MwLrhBh5NLL/E6MUT2qd
         VzQEkg9MFW7gBn9xAbMJ3aHfXpYEn/pILPzrH78xuCtHoMorWvlAlBy2/MW8BO5O7ngN
         9VRWoyDtHb5U26I6hBSa+g3+9XQ5IDWeEiUbe2+qVifFzCDiOLP1gnR07TRosY+2JGaH
         lbKbbhtxFzA4sUOx47+kEVylhRY6PQoiVxC4iMCgwxUG1Rf3xL96gXT9zDxWXrL4UjcZ
         ca4w==
X-Forwarded-Encrypted: i=1; AL+hErHQrJzH9SpK7cA7FqIIEmfLg6adP5+jmWSDUHM2rKoHuUy6Up2JBkYmtdkHm+mbeROYU4rQuwoj/9LG@vger.kernel.org
X-Gm-Message-State: APuU4Z9xlpA1stfpjfCdN+Ob4s4bLQhSeOrPWggf2Samb0KQJzodKCDJ
	uKOcfOtH6h2m2j3TkK3EYA06mek0atyJrgHG5OgWW9Vq+fTGmcepz3lJ
X-Gm-Gg: AYBFou3rDcNsj/KvAqeEy7fWNj+9FgSaGV1Tj5JWEoeJ+EpZC3WvNDqw2VUAXwyvRc4
	yxnoHVO+qxp45SewOtOwBBH+fBpgePwv0Gpg9oBsGv4Jzdk/t5SylQLO0Dlc423YvSfe0ViqH0G
	y6Y4o+Nps3hoXGgchzeVwcdiCZWSnHm3T6k5EYVm4S8KrUlUAo8MZWB9q6pxO7eC/l2+pOyCRrW
	/NYwtcnKAV2A/40BkMHI4y+6OGVLAJKEHGrR8geKbgcIIwK7sRlrRMETTTvzZAJo8jVohpFIV4Q
	LGbiRCyAJUfjwuelq6lzuU2PvCuTJgvwg40K8VR1F5CrRWHgxiCNq59eF9sBC3jfTZyHAG20VAE
	+8cOHX2tGfNujIDV3brwzXV0O7K/gfJkuMwvT5AyzBMLFIDssuweuGex0r2sAgl7kvWm4ZcjZ9/
	ZGwzSKyl+YLAx+Xgb1iC7vql3PWUh+TmABEDDWVQv3bCgmOAlOIxPS0n6f3B1f9V7lzRdLjc1oD
	cTEAF3PjSTFRbb0cqXxnrPVyTgeDt55GBFROm085Ad6VgXePg7A1mE2X0gLtcOS8R/bT0ZGe8ub
	EHt72pkYez0in5XeirDawl39nAn7fUKNI5zgvZpVpTdWq57gW02Dwj2+sLaoJUMwskYVgFCU
X-Received: by 2002:a05:690c:7342:b0:8b3:23f3:134d with SMTP id 00721157ae682-8b3a80ee26emr9648857b3.42.1794371035274;
        Tue, 10 Nov 2026 20:23:55 -0800 (PST)
Received: from ?IPV6:2800:a4:806:ef00:6378:bcd1:64fa:19e3? ([2800:a4:806:ef00:6378:bcd1:64fa:19e3])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933a165csm36073107b3.14.2026.11.10.20.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 20:23:54 -0800 (PST)
Message-ID: <fb4d03b3-eb35-4aeb-baa1-f4df54653192@andrewgigena.dev>
Date: Wed, 11 Nov 2026 04:23:48 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: ice: Document sm8150 inline
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,
 Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-1-d697bbce0278@andrewgigena.dev>
 <20261106-offbeat-hawk-of-purring-50a8aa@quoll>
Content-Language: en-US
From: Andrew Gigena <mail@andrewgigena.dev>
In-Reply-To: <20261106-offbeat-hawk-of-purring-50a8aa@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> This part should be a separate commit.

I splitted it into two commits in v3:
1. Add qcom,sm8150-inline-crypto-engine compatible.
2. Move qcom,sm8150-ufshc to the standalone-ICE UFS binding.

> And what about eight clock? All existing DTS will report warning? I
> don't quite get the need of this move.

After the move, SM8150 UFS no longer provides the ICE register region or
ice_core_clk; those live in the standalone ICE node. The only in-tree
user of qcom,sm8150-ufshc is arch/arm64/boot/dts/qcom/sm8150.dtsi, which
is converted in the DTS patch, so there are no leftover users of the
embedded-ICE binding for this compatible and no schema warnings.
