Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795132111;
	b=czl13vlWJiHy4+hnbVK5ETZDbyWM2z+XG8MhQyb3UDZL6QCwn31R/3eY5Nqlk0RAo6yU
	 YllciAk8+Lu0DimUcDcNxygRZl2kg1L6CAkVmoVc0SF3Ww0uclA3OlMTwgPDGmChtuVPm
	 YM9vJ1uvQcSzUY79Y6IGHK0z9vxlDfD/+mzpHPfnQvXbpVqLGiab0wrNfn2xZ4NddAWxz
	 V08xsBHA0hjLaBJHAzACyMpVdS11M9WiMvKM+0Neo7SR+hqPakdSuoWMjVLiGa/1b22Nh
	 DyrjMG2ZXgrjfEUMkUv+sPf9XypmRzzx2hzUO7vQOnkPb4ug2xiiimlx3y2nFnB+RqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795132111;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=vcj5h00JjVNcq5RcRanYbKv1qUq4spqkJwru3XjEgEA=;
	b=43iU1cGZrPtl3MHlT9cwb1YKN3f8apdcPt1LKKDjPENfhyrwh4SJQymiNRX9+piJ+heg
	 zFyG3J5gLbkeyPuhrJqLN+xHj71J9J6hlRyTTaMzQn+nWQmIvRdjqlXLqLgJJw6znLYeB
	 iu/IjsrwtA3rFatd6+jdpomDOW18OyUeLb0F3xM/xABqUmwSBYOR2WTVIhNWunVqnOP8I
	 30GGL9JpBmcqasKkg/gzdKYxYYNeKKzBmJwDw8xPRVJQXgnRjv7SI6j8/6DZQ0oLgjD9t
	 MfMzu+0vI5KFjVK9raWGAmO7PxIZRbvX1Vur2s8CUu3nvcevOpws29FPduujQb9zGmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BoTWH5Fi;
	arc=none smtp.remote-ip=95.215.58.92
Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8FB606A320
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 23:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A8FB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BoTWH5Fi
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6LWaP9a799dRmXjPzl0gkWLih06hsrqQYvPtGBFxEsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795132107; v=1; x=1795736907;
 b=BoTWH5Fi1IZExkaX1UVG0UE/sKHeD7yr0JBoEA7pSxpIS9I/AG/d2puwMNbDLQzs2vT11U1s
 vASgSWckzezIb9s1Sd0vB6uxw4uXPLLwr5GKRk1rBj9hLubjulj4/oLYePkSmiMd7yc+crCqZM/
 4ZhHgjLXJXGKVDcDNMWg5GdI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a9882a66356e0e59;
	Thu, 19 Nov 2026 23:48:27 +0000
X-Mizu-Trace-ID: a9882a66356e0e59
X-Migadu-Flow: FLOW_OUT
Message-ID: <583bde38-c84d-41a3-a65c-d1365ea04f07@linux.dev>
Date: Fri, 20 Nov 2026 07:47:56 +0800
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
 mhiramat@kernel.org, jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk,
 linux-mm@kvack.org, James.Bottomley@hansenpartnership.com,
 sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org,
 joro@8bytes.org, will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
 mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org,
 aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz,
 cuitao@kylinos.cn
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
To: Steven Rostedt <rostedt@goodmis.org>,
 Vincent Donnefort <vdonnefort@google.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev> <avScKhR22kFOQ1z4@google.com>
 <20261111181447.3c483a50@fedora>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20261111181447.3c483a50@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello, Steven, Vincent,

在 2026/11/12 07:14, Steven Rostedt 写道:
> On Wed, 11 Nov 2026 16:47:38 +0000
> Vincent Donnefort <vdonnefort@google.com> wrote:
> 
>> On Fri, Nov 06, 2026 at 09:18:26PM +0800, Tao Cui wrote:
>>> From: Tao Cui <cuitao@kylinos.cn>
>>>
>>> Creating an instance immediately allocates two full sets of per-cpu
>>> ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
>>> on the default config, plus the trace_array and its name.  None of it
>>> is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
>>> while user_events in the same directory accounts everything it
>>> allocates.
> 
> As the name suggests, "user_events" are for users and are special.
> 
>>>
>>> Instance creation is currently gated by tracefs file permissions
>>> alone, so a
>>> rootful container with the host tracefs bound in can create instances
>>> until the host runs out of memory.
> 
> You mean, "works as expected"?
> 
>>  Charge the ring buffer pages and
>>> the trace_array metadata to the creating cgroup.
>>>
>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>>> ---
>>>  kernel/trace/ring_buffer.c | 8 +++++++-
>>>  kernel/trace/trace.c       | 6 +++---
>>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>>> index 1fd28a72e6ee..676c059c112c 100644
>>> --- a/kernel/trace/ring_buffer.c
>>> +++ b/kernel/trace/ring_buffer.c
>>> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>>>  	 * gracefully without invoking oom-killer and the system is not
>>>  	 * destabilized.
>>>  	 */
>>> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
>>> +	/*
>>> +	 * The subbuffers are charged to the memcg of whoever caused the
>>> +	 * allocation: the creator of a trace instance, or root at boot for
>>> +	 * the global trace.
>>> +	 */
>>> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
>>> +		  __GFP_ACCOUNT;
>>>  
>>>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>>>  	if (!page)  
>>
>> Hum, by default tracefs is root only. 
>>
>> And even if made accessible to other users: 
>>
>>   1. The life span of a trace instance is not tied to the caller.
>>   2. The ring buffer is shared by multiple users.
> 
> Right. Is there a use case out there that allows non-admin to create an
> instance? Tracing ring buffers can expose a lot and should not be given
> to unprivileged users.
> 
Not that I can point to.  Instances are admin-only by default, and the permission layer is the right place for that.

> What exactly is this trying to achieve?
>
The series closes uncharged kernel allocations that scale with user input.  For tracing I misread the tracefs permission check as a gap rather than the intended boundary.  Combined with Vincent's points on lifetime and sharing, I'll drop patch.
 
Thanks,
Tao
> -- Steve
> 
> 
>>
>> Overall I am not convinced charging the creator makes much sense.
>>
>> Eventually a few allocations for iterators could be GFP_ACCOUNT.
>>
> 

