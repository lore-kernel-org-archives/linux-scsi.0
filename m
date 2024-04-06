Received: from cmx-mtlrgo001.bell.net (mta-mtl-002.bell.net [209.71.208.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE4B1E4B1;
	Sat,  6 Apr 2024 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.71.208.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712414030; cv=none; b=QzFnYCiXw/gW4ON2wO7YkrxKXWwtQFoo3VOO7i4UkTscw1NaFea3biZN2CUEdP0xmmzY+FlUgC6frxhnp8VkAJr0+wiC+WQ4F3hXOpESFWNJQVtMiVcKQcNJ5wq613BcI+pWOuXdf6SXTZBZAxNSW0EYCH9U37URIhlY5AUGIrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712414030; c=relaxed/simple;
	bh=2m1BXDw7eAxf21tAxvdQH8YfP/HQ7nj83HH+BHd861Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LyP24bZDYk/cQdtyff/vv0qhFTF4FPsC6R+XS8gnpqPSAukYXqPjm6pUYEKAMnzZt0FzhMVyGRVXT7ohmKPK92PE3mcOc3AOEqP9DY3FkH+OE7mwDjjGVXzZfXvTUmrFhK/MTH5/kXQfalRX+GcOtKd5TxLwp7ZXXFW+/qpRVyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bell.net; spf=pass smtp.mailfrom=bell.net; dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b=RVrdzwqc; arc=none smtp.client-ip=209.71.208.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bell.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bell.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bell.net header.i=@bell.net header.b="RVrdzwqc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bell.net; s=selector1; t=1712414028; 
        bh=tOe7n4kS7b3wIJvVSu0KDIE4PNiIUm+fc+4BQVwzmsA=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:In-Reply-To:Content-Type;
        b=RVrdzwqc/SL/UA7c5ckwhMeD22iQhm6K5CzaITGViq+7BI9D3zgH8Fn8t3bnEgPhYhvtZW8Cy+s7p86KE8ecubQ0FP+dJRiZCGhgHJTQEMAfCPskysm0zjzEdHmyN3t5/GjUmWue/AR1Nxi75T2I9ZkCrL/MaQRRkoONMmX0noNdkZXXxfKeayWBee1jRKQ3EhD4GxP3SlFUxiNGl9kTSCJz8b5mLvgF9eE9zrFQqsJnTpYBUNPcXgbfHEeACgirRoeJK64BMllQVrjogJy0gAc+FRizZLYrZIxASMJhuvRjs8UkttJWq2MVON2A7W6zJulZef+uVfMxssZbPSKsjA==
X-RG-SOPHOS: Clean
X-RG-VADE-SC: 0
X-RG-VADE: Clean
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 660659AA00AEF59E
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvledrudegvddgjeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuuefgnffnpdfqfgfvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomheplfhohhhnucffrghvihguucetnhhglhhinhcuoegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvtheqnecuggftrfgrthhtvghrnhepjefhvdekffdtfeevveffjefgleekieekleelgedtjefhgfeuledvheevudeivdeknecuffhomhgrihhnpeekuddrihhtnecukfhppedugedvrdduvdeirddukeekrddvhedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddvrdeglegnpdhinhgvthepudegvddruddviedrudekkedrvdehuddpmhgrihhlfhhrohhmpegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvthdpnhgspghrtghpthhtohepgedprhgtphhtthhopegsvhgrnhgrshhstghhvgesrggtmhdrohhrghdprhgtphhtthhopegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvthdprhgtphhtthhopehlihhnuhigqdhprghrihhstgesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhstghsihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgvvhfkrfepsghrrghsqdgsrghsvgdqohhtfigr
	ohhntdeltdeifidqghhrtgdqudehqddugedvqdduvdeiqddukeekqddvhedurdgushhlrdgsvghllhdrtggrpdgruhhthhgpuhhsvghrpegurghvvgdrrghnghhlihhnsegsvghllhdrnhgvth
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from [192.168.2.49] (142.126.188.251) by cmx-mtlrgo001.bell.net (5.8.814) (authenticated as dave.anglin@bell.net)
        id 660659AA00AEF59E; Sat, 6 Apr 2024 10:30:08 -0400
Message-ID: <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
Date: Sat, 6 Apr 2024 10:30:08 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Broken Domain Validation in 6.1.84+
To: Bart Van Assche <bvanassche@acm.org>,
 linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
Content-Language: en-US
From: John David Anglin <dave.anglin@bell.net>
Autocrypt: addr=dave.anglin@bell.net; keydata=
 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
 T70V9SSrl2hiw38vRzsl
In-Reply-To: <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024-04-05 3:36 p.m., Bart Van Assche wrote:
> On 4/4/24 13:07, John David Anglin wrote:
>> On 2024-04-04 12:32 p.m., Bart Van Assche wrote:
>>> Can you please help with verifying whether this kernel warning is only
>>> triggered by the 6.1 stable kernel series or whether it is also
>>> triggered by a vanilla kernel, e.g. kernel v6.8? That will tell us
>>> whether we need to review the upstream changes or the backports on the
>>> v6.1 branch.
>>
>> Stable kernel v6.8.3 is okay.
>
> Would it be possible to bisect this issue on the linux-6.1.y branch?
> That probably will be faster than reviewing all backports of SCSI
> patches on that branch.
The warning triggers with v6.1.81.  It doesn't trigger with v6.1.80.

Dave

-- 
John David Anglin  dave.anglin@bell.net

