Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.112
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794191748;
	b=zhEZhCUQEMz6uUW8MGTBDgw6hYyadnO8kspAA7l8p4OpStE1m2WQk8EwhTXO5WGRkaCQ
	 uFf6vIkGJ8FwdhmUhm6SsUWyXHW47EEa8FBS7POWIaLyscb1NlKwcMrDP+Ny5FJG6BE7s
	 3PNNlJpdCdgR6MbEoq6YHYs7ab4WyikAzLUQNJ+vEnQ/43r1Ur0FfovL3ulBTiqmDEH+g
	 fPsuKvR0lpVrReRKmKjPnyabzgDGGhhl5msd1TQXFTUoqNzBTseczzet1sbz4vBHH2eA2
	 cvdmBMrP1QF/0NMlnmX44YU3S4muwfvN3mbPgt0kJcw5JNfuOQgPYfNSK24Bz/bjlpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794191748;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Cc:Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=D8KACQV8GEkM7sg/l0LY+n4eIcnrDwVtQhDVvbChlsc=;
	b=bfzxpQX6VOrVv92ckK6KaZ5D85MfxBdUk0/fnzOMx+HmFiz8l/yBWR8e3ne7cLwQCYIn
	 oPfopY7MBveXbzqcQm1Fa/JejJP8UZ7rckVb9FIqNDMypeT24zZqIS5LNcED4i+ked3wN
	 cFBcHFzPemdxBG+gcOmXyjyC/DWD/MD3lI6WB6JosQnxT1W16yb/OWnqExJPPoEA2YXDF
	 3RigbuKSKpy0FUS/OgGXmC7ju1dU9tvSnKMgM6JFCyWHEWsexHP1YODXWU1p9zhgK4zsW
	 Cu3/up8CMLiOeiVqDS/zIY14FqCD4zlroFbFrJV0A2kJq84qX5XuLWLWo9xa0jx+svQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kA66ix4o;
	arc=none smtp.remote-ip=91.218.175.112
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26091606A31C
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 02:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26091606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kA66ix4o
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sahaBfdN8dM3MC+nyYsLDXJ4FM7JRPlU6iwwEbjUDHg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794191746; v=1; x=1794796546;
 b=kA66ix4oBjp4zQg4b2a4lEPHHzpy24nuFI7y8yO2hI6FUE4lwNDQ4yKfibzsxPzpKvAAm4HC
 QpvzQ7yTyFe49ekLtwGNhR3XsjclCoZHSbmaKqV/VIQni7chUMraprKVvYsByyjWC7eHBibwRYi
 l0GmyOWDwLf66w6+eS5BO6OY=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ccc0e3a2462894c9;
	Mon, 09 Nov 2026 02:35:24 +0000
X-Mizu-Trace-ID: ccc0e3a2462894c9
X-Migadu-Flow: FLOW_OUT
Message-ID: <f10075aa-0917-472c-855d-afabbc9697ff@linux.dev>
Date: Mon, 9 Nov 2026 10:35:12 +0800
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
Cc: cui.tao@linux.dev, linux-mm@kvack.org,
 James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
 will@kernel.org, linux-scsi@vger.kernel.org,
 dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
 bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com,
 robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com,
 tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn,
 media-ci@linuxtv.org
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com,
 jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com,
 mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com,
 stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org,
 vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca,
 kevin.tian@intel.com, axboe@kernel.dk
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev>
 <sashiko-outbox-202921@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <sashiko-outbox-202921@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

在 2026/11/7 21:27, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [Medium] tracing: alloc_cpu_data() mischarges global_trace and
>   read-page swaps
Correct.  Charging alloc_cpu_data() unconditionally pins the global
trace buffers to whoever first triggers the lazy expansion, and the
read-page swap can move charges between the reader's memcg and the
ring buffer.
> - [Medium] tracing: alloc_cpu_data() memcg limit triggers
>   trace_rb_cpu_prepare() WARN
Also possible.  With __GFP_ACCOUNT, allocation failures from memcg
limits can now reach this path as well, making the existing WARN()
reachable from a constrained memcg.  I'll avoid charging allocations
performed from the hotplug prepare path in the respin.
> - [Low] tracing: inaccurate snapshot size claim and inconsistent
>   GFP_KERNEL_ACCOUNT use
The snapshot size description in the changelog will be corrected in the
respin.
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [Medium] tracing: memory leak in trace_array_create_systems() [1]
That one predates this series as well.  I'll investigate it separately
and send a dedicated fix if confirmed.

The v2 respin narrows the accounting.  Only buffers belonging to
non-root trace instances will be allocated with __GFP_ACCOUNT (via a
new RB_FL_ACCOUNT flag).  The global trace, read-page pool and CPU
hotplug allocations will remain unaccounted, and the changelog will be
updated accordingly.

Thank
> --
> 
> commit a11da3138f9fda850c1b05bae82b0be7e738b994
> Author: Tao Cui <cuitao@kylinos.cn>
> 
> tracing: account ring buffer pages and trace_array metadata to memcg
> 
> This commit adds __GFP_ACCOUNT to ring buffer subbuffer allocations in
> alloc_cpu_data() and switches trace_array allocations in
> trace_array_create_systems() to GFP_KERNEL_ACCOUNT.
> 
>> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
>> index e760d2fe386fb..f925936378639 100644
>> --- a/kernel/trace/ring_buffer.c
>> +++ b/kernel/trace/ring_buffer.c
>> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>>  	 * gracefully without invoking oom-killer and the system is not
>>  	 * destabilized.
>>  	 */
>> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
>> +	/*
>> +	 * The subbuffers are charged to the memcg of whoever caused the
>> +	 * allocation: the creator of a trace instance, or root at boot for
>> +	 * the global trace.
>> +	 */
>> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
>> +		  __GFP_ACCOUNT;
>>  
>>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>>  	if (!page)
> 
> [Severity: Medium]
> Does charging every alloc_cpu_data() call to current's memcg misattribute
> global_trace subbuffers and swapped read pages?
> 
> At boot, tracer_alloc_buffers() keeps global_trace at its minimum size
> (ring_buf_size = 1) when ring_buffer_expanded is false.  global_trace is
> only expanded to trace_buf_size at runtime in tracing_update_buffers() or
> tracing_set_tracer() when a task first enables an event, sets a tracer, or
> loads a module using trace_printk().  With __GFP_ACCOUNT in
> alloc_cpu_data(), those global_trace pages are charged to whichever cgroup
> triggers the lazy expansion and stay pinned to that memcg because
> global_trace is never freed.
> 
> In addition, ring_buffer_alloc_read_page() calls alloc_cpu_data() when
> reading or splicing from trace_pipe_raw, and ring_buffer_read_page() swaps
> that reader-allocated page directly into reader->page while handing the old
> ring buffer page back to the reader to be freed:
> 
> kernel/trace/ring_buffer.c:ring_buffer_read_page() {
>     ...
> 		dpage = reader->page;
> 		reader->page = data_page->data;
> 		local_set(&reader->write, 0);
> 		local_set(&reader->entries, 0);
> 		reader->read = 0;
> 		data_page->data = dpage;
>     ...
> }
> 
> A host process reading trace_pipe_raw from a container's instance will
> replace the container's charged pages with uncharged pages and uncharge the
> container as the old pages are freed, while a cgroup task reading
> global_trace will swap pages charged to its own memcg into global_trace.
> Similarly, trace_rb_cpu_prepare() during runtime CPU hotplug allocates
> per-CPU buffers for all existing instances in the context of the task
> onlining the CPU.
> 
> [Severity: Medium]
> Can hitting the memcg limit in alloc_cpu_data() during instance creation
> trigger the WARN(1) in trace_rb_cpu_prepare()?
> 
> When alloc_buffer() creates a ring buffer, it allocates the first CPU's
> buffer directly and then calls
> cpuhp_state_add_instance(CPUHP_TRACE_RB_PREPARE, &buffer->node), which runs
> trace_rb_cpu_prepare() for each remaining present CPU:
> 
> kernel/trace/ring_buffer.c:trace_rb_cpu_prepare() {
>     ...
> 	buffer->buffers[cpu] =
> 		rb_allocate_cpu_buffer(buffer, nr_pages, cpu);
> 	if (!buffer->buffers[cpu]) {
> 		WARN(1, "failed to allocate ring buffer on CPU %u\n",
> 		     cpu);
> 		return -ENOMEM;
> 	}
>     ...
> }
> 
> Because __rb_allocate_pages() only checks si_mem_available() against global
> memory, a cgroup with enough headroom for the first CPU (~1.375 MB) that
> hits its memcg limit on any subsequent CPU in trace_rb_cpu_prepare() will
> trigger this WARN(1) and crash the host if panic_on_warn is set.
> 
>> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>> index 08614af8fad1c..fd1cfd1f66fbe 100644
>> --- a/kernel/trace/trace.c
>> +++ b/kernel/trace/trace.c
>> @@ -8677,11 +8677,11 @@ trace_array_create_systems(const char *name, const char *systems,
>>  	int ret;
>>  
>>  	ret = -ENOMEM;
>> -	tr = kzalloc_obj(*tr);
>> +	tr = kzalloc_obj(*tr, GFP_KERNEL_ACCOUNT);
>>  	if (!tr)
>>  		return ERR_PTR(ret);
>>  
>> -	tr->name = kstrdup(name, GFP_KERNEL);
>> +	tr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
>>  	if (!tr->name)
>>  		goto out_free_tr;
>>  
>> @@ -8692,7 +8692,7 @@ trace_array_create_systems(const char *name, const char *systems,
>>  		goto out_free_tr;
>>  
>>  	if (systems) {
>> -		tr->system_names = kstrdup_const(systems, GFP_KERNEL);
>> +		tr->system_names = kstrdup_const(systems, GFP_KERNEL_ACCOUNT);
>>  		if (!tr->system_names)
>>  			goto out_free_tr;
>>  	}
> 
> [Severity: Low]
> Should the alloc_cpumask_var() and zalloc_cpumask_var() calls right between
> tr->name and tr->system_names, as well as alloc_cpu_page() and
> alloc_cpu_buffer() in ring_buffer.c, also use GFP_KERNEL_ACCOUNT?
> 
> Also, the commit message says creating an instance immediately allocates a
> full ~1.375 MB per-CPU snapshot buffer, but trace_allocate_snapshot() passes
> size = 1 when allocate_snapshot is false (which is always the case after
> boot), so snapshot_buffer only allocates the minimum pages until a snapshot
> is armed.
> 
> [Severity: Medium]
> This problem wasn't introduced by this patch, but in
> trace_array_create_systems() [1], does the out_free_tr error path leak
> tr->tracers when trace_array_create_dir() fails?
> 
> trace_array_create_dir() calls __update_tracer() -> add_tracer(), which
> allocates struct tracers and struct tracer_flags entries on tr->tracers.  If
> a later step in trace_array_create_dir() fails and jumps to out_free_tr,
> nothing calls free_tracers(tr), leaking the entries already added to
> tr->tracers.
> 
> [1] https://sashiko.dev/#/bug/linux-9449d18e-1233-4181-9199-09eaead7b576
> 

