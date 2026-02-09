Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909325DB12;
	Mon,  9 Feb 2026 21:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770672413; cv=none; b=gkUvjRhk6hJTCnaWp2IwDLfSyi+02IYV+qzFrHxXnaWNnYatx0cVK7UH3VheTTKYIgzi/69yCTrmHOL2OR6UZUJV/LAVuLFuqZ+nbVQEOzDzimakznk3NVyqhpPrlFN9QTWugEA9RnjPFA2Ik2FATAseNHpgSzdpOuvwYDltBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770672413; c=relaxed/simple;
	bh=6mIU3Bu8hC+Jz6m03yEqAZNJUwSNuiDh/RPcTfgdnGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXIbcE188bYVXrZWcR+gtAqeaoBKojlmFEreSA0Z2nSs2SaXNdGgp+jF4W+6tU7DVut5MOrw+RG8RvrFKLU/9l0zlL57Rda2nJHW1ADw2ntqYl4dm+Ffx+AYUx4pcvvoDeigidBAzJSwh3hOX0ilBsKpAn+8uKJmoJqOLnrMhhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OM83KAGb; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OM83KAGb"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f8ySX2R7HzlfddR;
	Mon,  9 Feb 2026 21:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770672410; x=1773264411; bh=PwJK6C7uj+PdiSlpFRWiuAs5
	zIA0mKj5gLHCNH7N1Zk=; b=OM83KAGbO1+o0h4kxxvvtejeAFNKNyQ95fCne0bA
	K6YhC6RM3FZsrKdKNtEhd3Pp4/k61ChcvnARRKdBwW/RSubGTSW/uO/ML1hVjRx+
	ucjoNAkTlQZFVoEaXN3LD8Zf0Q0TglUMhzxThQMcMBtqCYnnHUbHnEB8G6JHlBqd
	ar5Cnq5G0r8N/wJl8ZUJz1Ek0ktAHs1AkeqfNxtdagRLgc+GKf6U//r94HaGQJ+x
	rRYRRKHgEi3l/tzeDeLKLH0Q22bS5yJy51GeS4d+gBRNdk55PFAAWRlE0xbOfRmZ
	tESeZcfXYur+bL6PJ8QevuZduz0ZjgYqpg7nB2Dr25xTWQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L55xXk_P6xjf; Mon,  9 Feb 2026 21:26:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f8yST527kzlfddn;
	Mon,  9 Feb 2026 21:26:49 +0000 (UTC)
Message-ID: <7a6077b3-0be0-4447-ad69-973a4f064a8c@acm.org>
Date: Mon, 9 Feb 2026 13:26:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Block storage copy offloading
To: Keith Busch <kbusch@kernel.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 lsf-pc@lists.linux-foundation.org, Jaegeuk Kim <jaegeuk@kernel.org>
References: <0cfe6fe2-3865-4dc2-92a7-74b1240f7b63@acm.org>
 <aYPdHYvuLeIevwUJ@kbusch-mbp>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aYPdHYvuLeIevwUJ@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 3:58 PM, Keith Busch wrote:
> On Fri, Jan 23, 2026 at 02:19:44PM -0800, Bart Van Assche wrote:
>> Adoption of zoned storage is increasing in mobile devices. Log-
>> structured filesystems are better suited for zoned storage than
>> traditional filesystems. These filesystems perform garbage collection.
>> Garbage collection involves copying data on the storage medium.
>> Offloading the copying operation to the storage device reduces energy
>> consumption. Hence the proposal to discuss integration of copy
>> offloading in the Linux kernel block, SCSI and NVMe layers.
>>
>> Other use-cases for copy offloading include reducing network traffic in
>> NVMeOF setups while copying data and also increasing throughput while
>> copying data.
> 
> I'm interested in the topic. I'm just not sure about the approach. If it
> doesn't support vectored sector sources, then it's much less
> interesting. From the host point of view, I'd like to be able to submit
> arbitrarily large bio's to the block layer that can be split and merged
> for optimal alignment to hardware limits. The two-bio approach looks
> overly complicated with respect to that.

Hi Keith,

How about supporting vectored sources with this approach:
* Copy requests with multiple discontiguous input or output ranges
   are submitted as multiple bios - one bio for each contiguous range.
* Before these multiple bios are submitted, blk_start_plug() is called.
   After these have been submitted blk_finish_plug() is called.
* After device mapper LBA translation has completed for all involved
   bios, if all involved bios apply to the same input and output
   block devices, and if sufficient requests are available, the block
   layer submits all the translated requests at once to the block driver
   by calling a new callback pointer that is added in struct blk_mq_ops.
* The block driver is responsible for combining the discontiguous
   requests into a single copy offload command (if permitted by the
   device limits).

Thanks,

Bart.


