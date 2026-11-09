Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.168
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191586;
	b=G8kBP9wIZdAC09pRmHoyFB0ulh//Bb9IJE7+G+9X3vSqkSauPPOcN80HWWX7gbOHB7Cu
	 ieu9KJOujpiCEtsGWR4X+lsqgto6VVcmHtTT5kJmb6ZM336MlPRkGDHx1ZR7Ap4Z38EwP
	 6N8Uh46FfuCBBck3AnrsCifun0eW3kwqLPytjBRqc3g3xzYr416hmvR/mvcHpaHRhpACI
	 /w+7A7sgtsgnDDRWHDefc0L+xZMPlrkx4gupyzkWNHzHcfksN4BDK8zrYucChry5NEnBj
	 kRa4OhKk8rMw7l/BoAATRbzt2b5tlu1OOZOjsFm2LacKs7A2OUwurFKkSF9oxG6m4BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191586;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=kB3IFpQ0ZIO1cp7bsYqiegxOLRHS/D0OEp5d5P2E9bs=;
	b=mj9nqUiLByEMkzSz3fzfrAePvaBfPRj0NjjvrIaY9dyDA0u9jYmdk9FEVAkHPNMSHDkX
	 8IPCi4IgrUarvuy+yHcwL3c/BMUKj3zyC4FopuliQaSNyUxEgtUvKsMXdeRijEzyO+iuv
	 o9wk6656lLulsZ7A7hv4HwJe4n5g09P7elbfkxLdc7GQCNH07z62pqDmjpGMxMDklMFmo
	 YrqWf4tUtql/g8tj829t4B5BQI2XeHGbZooWh8fEx78/ZYb+Ogpf1k1ve9N9WU4Ia9BQg
	 t4DgdyUsJJV/l1ZpIgm4Bl6HcE/aADUeMgAtW4o4e5caKh8RN9DABJRmHKtGDfBjbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ojX0EpIo;
	arc=none smtp.remote-ip=95.215.58.168
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6964606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 02:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6964606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ojX0EpIo
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nmqRaiM/EiJNizjn79AmK4k2MmWrkYTwEz2GWquosKA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191583; v=1; x=1794796383;
 b=ojX0EpIoXW4Q3WWoKTSHFyYfVB5/NGKPMoZkCmCbZqBScUyhu6sLm3yjkz3APWW4PPjlGsGs
 08BhfDJF0/bIs+cEwtmQZ/pXWdCFPiZK/kLkGbfQD3yI047xH2MZMmKuO4QwBQXVhNIdwf/A+O3
 H3ZmjPkz0bDxno5X6rlhxv2w=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id fa418301c63af391;
	Mon, 09 Nov 2026 02:33:03 +0000
X-Mizu-Trace-ID: fa418301c63af391
X-Migadu-Flow: FLOW_OUT
Message-ID: <c6bf9ef4-5a61-4f4f-ab39-11d1ddf59d64@linux.dev>
Date: Mon, 9 Nov 2026 10:32:01 +0800
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
Cc: cui.tao@linux.dev, akpm@linux-foundation.org, dgilbert@interlog.com,
 mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
 vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
 eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
 rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
 jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
 James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
 phasta@kernel.org, joro@8bytes.org, will@kernel.org,
 linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, iommu@lists.linux.dev,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 2/7] dma-buf/udmabuf: account the page array metadata to
 memcg
To: "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-3-cui.tao@linux.dev>
 <1e18fcfd-785d-43cc-afd6-d181bf8305eb@amd.com>
 <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <CABdmKX0nCB2hT+iMh=BB-nC=fUBPof8YvjvO-gtEw+zcHZgvZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello，Christian，T.J.

在 2026/11/7 01:25, T.J. Mercier 写道:
> On Fri, Nov 6, 2026 at 5:23 AM Christian König <christian.koenig@amd.com> wrote:
>>
>> On 11/6/26 14:18, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> udmabuf pins the pages of a memfd and hands them out as a dma-buf.  The
>>> data pages keep the accounting of the memfd they were instantiated in,
>>> but the bookkeeping around them does not: the page pointer array and
>>> the pinned_folios array, both sized by the buffer page count, plus the
>>> transient folios array sized by the memfd folio count, are plain
>>> GFP_KERNEL.  A 1GB buffer costs about 4MB of uncharged SUnreclaim
>>> memory, and size_limit_mb defaults to INT_MAX.
>>>
>>> Charge the three kvmalloc allocations so the creator pays for the
>>> metadata it induces.  The system heap in the same subsystem already
>>> accounts its buffer allocation;
> 
> Only if the mem_accounting param is set to true. We (Android)
> currently depend on it being disabled because system heap buffers
> don't have a single owner for their entire lifetime (ownership often
> changes immediately after they are allocated), and the kernel doesn't
> have the ability to switch who is charged for the buffer memory quite
> yet. Albert is working hard on it at the moment.
> 
> Could you update the message to note the mem_accounting param pls?
> 
>>> the data pages here stay with the
>>> memfd.
> 
> memfd / udmabuf is a little special because it uses shmem for the
> backing store, which is already tracked by memcg under all conditions
> (except hugetlb). We don't currently use udmabuf, so the lack of memcg
> charge transfer for udmabuf is not an issue. But once we get charge
> transfer working for the system heap it'd be good to follow up with
> udmabuf.
> 
>> T.J. needs to take a look here, but I fear that this might break uAPI.
> 
> Thanks for looping me in Christian. The buffer allocations cost
> gigabytes, but these metadata arrays are only 4MB per 1GB of buffer,
> so I don't expect charging them to break anyone. Leaving them
> uncharged is an accounting gap though, since someone could spam many
> udmabufs from the same memfd and only pay for the memfd pages once. So
> this change is ok with me.
> 
>> A lot of the DMA-buf resources are intentionally not charged against memcg.
>>
>> Regards,
>> Christian.
>>
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> 
> With the commit message updated to mention the mem_accounting param:
> Reviewed-by: T.J. Mercier <tjmercier@google.com>
Thanks, Christian，T.J.

I'll update the commit message to clarify the mem_accounting parameter
and pick up your Reviewed-by tag in v2.

Tao

