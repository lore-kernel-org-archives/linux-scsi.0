Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792696928;
	b=RNkDP00YwdXdSQo9RtYONFmycZBrswdfiD6sYA2TGdvec+LPgR8/hEpAyuL5ZlrrnrVM
	 YBSt2uwN9rl+Jzobh6FjxANHS/rPVN36oMhexOmKZxfrBbPGXvwx0Ejeqnksw+El4/8pG
	 YVQDojn+TJ6Ddr9fReyKPttQHiLUsnFN3tyYCJgJvl1cCGsyTyKWHuc0209pABOGm8fGv
	 vbCUuC/Wb7Fs0d7z/RGEP8KSaGHImhne7EtA44CB8UNPHY7pDxacGXSfajXzCI5i0Cpfl
	 PWU5Km3KZzM+lpADY+fkikGP5cF/u7eDW8TPsPB5V9walfpQxgElDhI3FOImE1nCbLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6wwXNu+Bc04sBeF05magzQmb3aIDtO2qxmFsPQee22g=;
	b=s2/V+p90m3DBLq2SKebpDDAlzW+4O6rJ6WEEAu9OWELrEyGTU4bcNsotb+ndBZVTNxWS
	 Q8lmPjy3eVw8r2YxNWLZ9Q1/PviV9fQ2rVN8QsSpMDKhd9CufpdMo1X8tN6NViinWvGtU
	 5cLu5SePbmBMWBq66HX6lE+2PCyV7GZje6R+vQyP6ro2Np/qEgH5WvgmBSWRyzZL90iWa
	 m9Hd8HJO1pLnw4Y9S30an8TpigzS7//EedxDofezX4iFgrHEL8b5QolM4TImdgHGI+8ZK
	 tsvLmiRvClLC8SM93Wazjn5P+EyriAiP/ivLFJxvj+jAdyBLiQV7sij8Y2m8GGXkIJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Ctr1fYd8;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F2E606A319;
	Thu, 22 Oct 2026 19:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33F2E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=Ctr1fYd8
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j9bcv4lzJz1XM4Tn;
	Thu, 22 Oct 2026 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792696924; x=1795288925; bh=6wwXNu+Bc04sBeF05magzQmb
	3aIDtO2qxmFsPQee22g=; b=Ctr1fYd80Cq+Hm1eLtO1tTfVNdyhY28xu+XGilQC
	071c/tmnifbheiWvC+ixnfZ4GkFglYiJATKNV38Fc7rxgoQOSk8OCsG5IgTd2jSd
	E8C/Nok5w/ESVWrNn8wr80SuFuUP/0iX4TzoQOTmxFm2i8A68SSYVeV3UCVZ6+3W
	jtrt37NrDeG0N97cTSouGZVt7fVEVLfu9f76Eo6LtQCIAfcg0quAQUmk/k8eh6Zv
	gwDShe+CdQFjKcNq6jRqGcidSKfWOoSPVKE7I4pQZcO9TJjpjRQeHe6y4943ZN03
	tBn+UW2nebPmT8ow+h2gNkOw94jC+VtSWugxS8CSVrxbPg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zONcWwz_23AS; Thu, 22 Oct 2026 19:22:04 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:356:46f6:e804:1d44] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j9bcq4Yynz1XM4Tl;
	Thu, 22 Oct 2026 19:22:03 +0000 (UTC)
Message-ID: <4e2383f0-9791-4840-a4d9-93fbe51b7a40@acm.org>
Date: Thu, 22 Oct 2026 12:22:02 -0700
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
Subject: Re: [PATCH v2] scsi: arm: Convert acornscsi-io.S to C
To: Breno Rodrigues Alves <breno3011alves@gmail.com>, linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com, mkp@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022185224.60700-1-breno3011alves@gmail.com>
 <20261022185224.60700-2-breno3011alves@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261022185224.60700-2-breno3011alves@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 11:52 AM, Breno Rodrigues Alves wrote:
> +	while (length >= 16) {
> +		u32 w0 = readl(card + 0), w1 = readl(card + 1);
> +		u32 w2 = readl(card + 2), w3 = readl(card + 3);
> +		u32 w4 = readl(card + 4), w5 = readl(card + 5);
> +		u32 w6 = readl(card + 6), w7 = readl(card + 7);
> +
> +		card += 8;
> +
> +		((u32 *)buf)[0] = (w0 & 0xffff) | (w1 << 16);
> +		((u32 *)buf)[1] = (w2 & 0xffff) | (w3 << 16);
> +		((u32 *)buf)[2] = (w4 & 0xffff) | (w5 << 16);
> +		((u32 *)buf)[3] = (w6 & 0xffff) | (w7 << 16);
> +
> +		buf += 16;
> +		length -= 16;
> +	}

Why eight readl() calls instead of a loop? Additionally, please use
put_unaligned_be32() instead of open-coding it. Is the code below
equivalent to the loop above?

	while (length >= 16) {
		for (int i = 0; i < 4; i++) {
			u16 w0 = readl(card + 0);
			u32 w1 = readl(card + 1);
			put_unaligned_be32(w0 | (w1 << 16), buf);
			card += 2;
			buf += 4;
		}
		length -= 16;
	}

Thanks,

Bart.
