Received: from smtp.domeneshop.no (smtp.domeneshop.no [194.63.252.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33730F815;
	Sun,  2 Aug 2026 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.63.252.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785693695; cv=none; b=CS/q3wrpHutOuptg0CWSjFesJAK2eoC3iZ8rHnX5Pfa1/QrqNBBeO+fqowunHJwwYHMvcLQeeTqOsKypYG8O2jbyz5HAfk4WQojnoDtxmgyvmmC1fddhjj4/8ECpLC7YI2qjuqoKbknHQTVdh+dUYspAL0CKeFOo3CDA3xKPxzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785693695; c=relaxed/simple;
	bh=NaMcNmlzRFYdF2dJ0ejCrjXm1acorDWmQPz2mPpw0ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RF6/Td5bhWguFVIvuj1CV7LUo0Vhild2Kr3IhD7qA3LuQ0lvPY+WXwrYn2xqocDwrUSXZMrVm5iCP9r8nxUn7DaCPM/JtCvnz08tCUrMJqbIxk+U+8ARj5pPdlPi8RGGqJk9vNBvEaQZ4s9pd36iZ0ZkxGgr+bd9nqpG1rl2rmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=skogtun.org; spf=pass smtp.mailfrom=skogtun.org; dkim=pass (2048-bit key) header.d=skogtun.org header.i=@skogtun.org header.b=Z55dNHu6; arc=none smtp.client-ip=194.63.252.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=skogtun.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=skogtun.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=skogtun.org header.i=@skogtun.org header.b="Z55dNHu6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=skogtun.org
	; s=ds202512; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:Sender:Reply-To:
	Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:
	References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:
	List-Owner:List-Archive; bh=qZUQ35X7VapCPh9gbSpwh/V8K0PsoREp2KIjj4zi5iQ=; b=Z
	55dNHu6PBwAMZ3E0bg8eLeoeE3fTLA3Bq9vRa1RZk4Ps1/x9DZLdQ92whTRnYbxJS8t5U08glGW8h
	G1jb78pF7Q50B2S22hRCdAw2uTmWWDrGtDKl2ibC9Hjb+9LnuA/kaPpa3hIWNQHjDLu2Fzm8xjHnz
	nXBEGl2dsFRE6ZqTuEaGZfx9LC/lDOcNWvts5TYf2/P7Sj3mWhOKFPDwQishcf2/IHAMWYkGmte+a
	owWKbv3OZpkD5NJA+5B7SubsZ7M5KgVfLvE6+7viSYQ3Dxni0hq+SW/wHIUwkVVKNtz2BvvKbBtOp
	3ddU9AJEp4O7a5Cs1ejeWrBhij4HPyoGw==;
Received: from smtp
	by smtp.domeneshop.no with esmtpsa (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	id 1wqaV4-00AEqH-1L;
	Sun, 02 Aug 2026 20:01:26 +0200
Message-ID: <44b46cb1-6df0-474a-9a74-00aae5c81560@skogtun.org>
Date: Sun, 2 Aug 2026 20:01:24 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] SCSI fixes for 7.2-rc5+
Content-Language: nb-NO
To: Linus Torvalds <torvalds@linux-foundation.org>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-scsi <linux-scsi@vger.kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>
References: <62fc8f5dd0e1e9ac6d512e84173d33e4676adc35.camel@HansenPartnership.com>
 <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
From: Harald Arnesen <linux@skogtun.org>
In-Reply-To: <CAHk-=wj-HxDeuQ0LLf8qmzZ9zJTq2o6Q3LOtcNhqR_pS=LUFAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds [2026-08-02 18:33:13]:

> On Sun, 2 Aug 2026 at 05:51, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>
>> Sorry for the last minute pull request.  This time I managed to spill
>> soup in my laptop on a business trip and fried the motherboard, so I've
>> only just got back home to a desktop.
> 
> That's the oddest version of "my dog ate my homework" I've ever heard.
> 
>               Linus
Several years ago, my sister spilled fish soup over her daughter's 
keyboard. My sister phoned me in quite a state, asking what to do. Power 
off, out with the battery, I rushed there to remove the keyboard.

We managed to save the computer, but not the keyboard. My sister got 
hold of a Turkish keyboard, which her daughter used for the rest of the 
life of that laptop.
-- 
Hilsen Harald
