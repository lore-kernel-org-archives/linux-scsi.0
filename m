Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EDF1844;
	Thu, 18 Jan 2024 00:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705538612; cv=none; b=XW5z9MZsi85dIp85Wdu62es2tUAcUlbUpQeu3aaAYMpHBn0intVOWH/bLOHTyQwHmCPtrAWHSSeDtVQWGZOLv+5Y9nqS5fA5JO7aQkOxQ6b6n500PbTBYvv2OHg3fDlOBJkFpndctUgRkJ0uQDIDcTZb0SE79/6Wcb200mi/CKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705538612; c=relaxed/simple;
	bh=Q4jZNmkfVaO8ML1kjEyBQBO98+D6ldHQpRFItWbS4eE=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:From:Subject:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=Wb8AZ8ErAvBMl+s4lESbRIVjpzXI/I6xCpUQcBqZV11ZNsDxMsZycCK36WI7Ct5zMEEZA+k1v+xns3pJk/IJxXrQaAQrSIkSpxEZrv4MHH/c2wc+xV38uDrw228CKss/YITQbmEjL+hDmnlZFEw5srXmUu6tvi4J41zSssHAF30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6db9e52bbccso749812b3a.3;
        Wed, 17 Jan 2024 16:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705538611; x=1706143411;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/Mec/5p9+EKLAFCABKLzW46J1sVgHE5SuS/MOmf2rY=;
        b=Zn8PhPnoIzWcxlnRiy6frERjl/EFeiAGxgJbNOzXPzG9YspLHkCuDvmjtWMOpZCWmW
         D214DU/hQcwkwJDk7SYMSkMA4JQdw6LT5I/u/oxb1i2M2aPdkV0439rDw5sZuRjNX8dw
         62S+TJUHcU8MuZbZ0i1rFMtW7h9cr5nCtYbo+AS+zfLHKlW1sJLZVX2QM7ZDJs14fnOQ
         qQr/MFUpOFyQ7vzcLjhQ74vpDys6PPhR2WgRNP3B+I1+Dnesi6vN0PVU8jNzkb3SZPyi
         SeZfM/CESmHr/F5omDk+IZrpdwbZpqaeAIIL/wHSUww49EnQ0g9VxIwCtVQizUKxmOG0
         XcIA==
X-Gm-Message-State: AOJu0YxVR6IpkU9DZkmG+OTo+3gAId4GMJ6W0lkgcf9Rgb7KGIGJ4/4O
	gQ6ol41wW2wvoX+gTa0LbZSnkbHxXeWmCEovc00ybePdgqfwmvxN
X-Google-Smtp-Source: AGHT+IHapUT+JiDEqszaul6msXCqfsq0Mpjjz9hiim4Ceamg2aEC5IDtO0+h7Jgsa5NB8G+B/jANwg==
X-Received: by 2002:a17:902:f551:b0:1d5:746a:de1 with SMTP id h17-20020a170902f55100b001d5746a0de1mr143778plf.64.1705538610518;
        Wed, 17 Jan 2024 16:43:30 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id lg15-20020a170902fb8f00b001d5e996ed4bsm229711plb.263.2024.01.17.16.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 16:43:30 -0800 (PST)
Message-ID: <08d22893-9a05-415e-a610-9b1ceaaba96a@acm.org>
Date: Wed, 17 Jan 2024 16:43:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <276eedc2-e3d0-40c7-b355-46232ea65662@kernel.dk>
 <39dfcd32-e5fc-45b9-a0ed-082b879a16a4@acm.org>
 <9f4a6b8a-1c17-46b7-8344-cbf4bcb406ab@kernel.dk>
 <207a985d-ad4e-4cad-ac07-961633967bfc@kernel.dk>
 <e8c32676-114b-4aaf-8753-5a6d7b04fc4b@kernel.dk>
 <86a1f9e6-d3ae-4051-8528-13a952cf74a1@acm.org>
 <90de77e4-ed8a-47be-b5df-2178913ec115@kernel.dk>
Content-Language: en-US
In-Reply-To: <90de77e4-ed8a-47be-b5df-2178913ec115@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 13:40, Jens Axboe wrote:
> On 1/17/24 2:33 PM, Bart Van Assche wrote:
>> Please note that whether or not spin_trylock() is used, there is a
>> race condition in this approach: if dd_dispatch_request() is called
>> just before another CPU calls spin_unlock() from inside
>> dd_dispatch_request() then some requests won't be dispatched until the
>> next time dd_dispatch_request() is called.
> 
> Sure, that's not surprising. What I cared most about here is that we
> should not have a race such that we'd stall. Since we haven't returned
> this request just yet if we race, we know at least one will be issued
> and we'll re-run at completion. So yeah, we may very well skip an issue,
> that's well known within that change, which will be postponed to the
> next queue run.
> 
> The patch is more to demonstrate that it would not take much to fix this
> case, at least, it's a proof-of-concept.

The patch below implements what has been discussed in this e-mail
thread. I do not recommend to apply this patch since it reduces single-
threaded performance by 11% on an Intel Xeon Processor (Skylake, IBRS):


diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index f958e79277b8..d83831ced69a 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -84,6 +84,10 @@ struct deadline_data {
  	 * run time data
  	 */

+	spinlock_t lock;
+	spinlock_t dispatch_lock;
+	spinlock_t zone_lock;
+
  	struct dd_per_prio per_prio[DD_PRIO_COUNT];

  	/* Data direction of latest dispatched request. */
@@ -100,9 +104,6 @@ struct deadline_data {
  	int front_merges;
  	u32 async_depth;
  	int prio_aging_expire;
-
-	spinlock_t lock;
-	spinlock_t zone_lock;
  };

  /* Maps an I/O priority class to a deadline scheduler priority. */
@@ -600,6 +601,16 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
  	struct request *rq;
  	enum dd_prio prio;

+	/*
+	 * Reduce lock contention on dd->lock by re-running the queue
+	 * asynchronously if another CPU core is already executing
+	 * dd_dispatch_request().
+	 */
+	if (!spin_trylock(&dd->dispatch_lock)) {
+		blk_mq_delay_run_hw_queue(hctx, 0);
+		return NULL;
+	}
+
  	spin_lock(&dd->lock);
  	rq = dd_dispatch_prio_aged_requests(dd, now);
  	if (rq)
@@ -617,6 +628,7 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)

  unlock:
  	spin_unlock(&dd->lock);
+	spin_unlock(&dd->dispatch_lock);

  	return rq;
  }
@@ -723,6 +735,7 @@ static int dd_init_sched(struct request_queue *q, struct elevator_type *e)
  	dd->fifo_batch = fifo_batch;
  	dd->prio_aging_expire = prio_aging_expire;
  	spin_lock_init(&dd->lock);
+	spin_lock_init(&dd->dispatch_lock);
  	spin_lock_init(&dd->zone_lock);

  	/* We dispatch from request queue wide instead of hw queue */

