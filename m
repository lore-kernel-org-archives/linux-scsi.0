Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794858736;
	b=Ldn4fCD9ag06UCvZl/SmnjZVkzQQpXhcGUwkfkM6UGqkzBhNiAeU2tMczT/dg8xznsaF
	 w6d+nvknaBvyFfnKm24o0f7gRJE9CIagPGA7L+H8alNuFkzEWQ+Bc3xOkGC0qJ5M4gopP
	 dixpYtR3DrMCwyyhoYLYNr4vRkFg+9Yg1ZbsaL9G0q/dZbH6MQCzNAKT9mgJIbljeYcPh
	 GBhF9nPCl/qHVVYhE31qBwas+t2HrwYEUVARV+MsuNTFj7UpqRufqdAJt/88tvgra09aj
	 lHj79K0Ti7YsFbyqVX8HeAmBSyzRehWZB34AtG2Z8LBa05Wnluo9f6kT13iH1omITng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794858736;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
	b=b5+Uczqul2WkuP6dPgl2B0GliZ9k8U+s+WHmFEd17sg2uL+DSn3Q+kg1wmKFKYTllNl3
	 GRwB/JNKxfmoiAOvtTR4w1O1A+hM/j77rXxvWyCbu8qCaYgUF/ruNZ9Tq87eMQ43uHjkr
	 vxjoijF2Bx9kZdmrPb1/Iqi1R4gSgs2Ltxv8V9cJezJJzpknpPdEegkLKNF2vh3RJBafO
	 ZB0NJFZslJDNkfbL2niWidjpX//YjtjEaNG5XLD3AxbSA0/TNVzZ6odvaeX5/elbi4R3m
	 25Imd5sDgEH/Wlk6TPO7CjL8VfCOE3vqsQTA9XPRa1DdmKNVyHdT6i/leGZiMHtNzCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=YcqWJI31;
	arc=none smtp.remote-ip=209.85.160.181
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B0D606A322
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 19:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B0D606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=YcqWJI31
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-55c38cdd5b7so33737811cf.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 11:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794858735; x=1795463535; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
        b=YcqWJI31Q3We3zqNvL52aNkFr++cowdUSJ0aOSCLtCZgOyPTfxfZMV4aawKPfLKj7g
         4m2sGeUiA0CXGadMrFuMRIl89TE0lacup406nbrhvwqwPIX8FxoVlYidwE8/s7P7Wszm
         OrbfdLGk33YGmzpkBYmsq4F3Mxnt+4Lu+TymHPjdbgW2SfeAeQs52uRWqh/1XVhhLOxn
         GvpMlDfLIXvCkNJG/BKPMpLBeKmXfFzSUPrKKeUURMUv+fsornqCLKr9GiRTo2LK7Tab
         rlciZWXd7u0mEyCoyMVRbS74CtgQ2ZcTLr22IpH7H7u3DgVnSQkVWAwVkGPORAQHY8UQ
         R7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794858735; x=1795463535;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jqnrRoTh5TcWr/Py+gEgzzX7wdMhzTlFxFkfLcpGuJM=;
        b=Y+nruu464OYpYFKoOEpiadi0vLF0BiSe3UJ8Ku0lYQCXCkLV1z3lEY6EDRssuzDU2O
         34GIcw8l76qiNyxVHQj3UBBA6ceGhQBE5HElVe2lulUrtMW5ZPsFpXiM2ZqmK5WvOD4j
         9Yvu56L0NryV2lOqBsQdWl0zZURs68BgVyyF/z7GqPE3oDP5HUVfHKfpLjcyOb5AzKzt
         exgD7YyE16iVEKw+SlVn82hGvId1kIBpWB92JajlV+m9qXPJ/IY0O27CAoDuEf5RtBl9
         Luv8V9NMEH0Ap6MeYXPQKTsmzpzy45SZxX7pEiTdOaUgcoHlnfdTabVwCTMsNw/KlY41
         e9jQ==
X-Forwarded-Encrypted: i=1; AL+hErF9RPm7GZXm5TlNkYeQ1PKCs0iRXP06kKSkFNjrM40JXW9NvtUDkyRU7GYD4/FSvZ0ATr6/kriWdfWx@vger.kernel.org
X-Gm-Message-State: APuU4Z+Rnftm/IauoE5JBtFK4Q+SlHAmEUb+Dh9pxqyIMSfG5X5vOl+n
	E27pwIIjy6F6QSWI5TVhSkTHOGMcXfpvrCcCKu6M47MEIz57o5DLkgEzq8soiAUZ5B4=
X-Gm-Gg: AYBFou1W26xfrqoC1TdL7y7UE/ckh3siUfdsg8B5aEhpMXqR5kx393CLgW39boqT6Ky
	OpxVmePZ+w/m1GzImYIpIwr5XsuIbnNG4JphBJPllk7STPtNO2LkY+DO7bGBQXIMqXcbO0jIHeU
	u8//nE4vQhS0ozopB/XjWgIMhQlHUO3zHnWVvKEl/t7bw/dW4BQ22paVRFePDiEVe9uMjM7JM7Q
	hRFX3xICOgKoRYOFecqxTGvHP1+YtvE2eK4OspVdDxuYcROpguZ30zzmIhROW9afp+YEiPkwhO4
	qSL6/OEDgKboelrKtiAdMIM6Xt1r/VGq6kcw8amWxWkpQXpE3ibgBvt2Ik+YJUbxzlpmS466yrQ
	kqlEfkBIq6up3FUEPvNkIacmLi6Q19rp56cqRLOeyTf7hpL1mL29Le/CR9bYyrLQQ0Qa1f/jWp+
	Q+x6w4ODOAYt3dh8s/vnRxYnGirqNoVf/lU6CD47wLRbzjG0v3ByqU/3AYW+n7/eVbBmqpMKO6K
	kHVTLweusNFQHiAqa5osoS4wpzF/AQllplKRSfWO8+R1X0THlC/9JhqM5HE2XjAXia91cD+3e3i
	S9eY7w==
X-Received: by 2002:a05:622a:13c6:b0:55c:c7ab:4445 with SMTP id d75a77b69052e-55cc7ab469bmr121785021cf.29.1794858734926;
        Mon, 16 Nov 2026 11:52:14 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f8319d44bsm48973876d6.4.2026.11.16.11.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 11:52:14 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xT2kP-0000000ALbT-12cG;
	Mon, 16 Nov 2026 15:52:13 -0400
Date: Mon, 16 Nov 2026 15:52:13 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org,
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
	will@kernel.org, linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com, robin.murphy@arm.com,
	mason@kernel.org, aesteve@redhat.com, tjmercier@google.com,
	harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 5/7] iommufd: account the hw_queue page array to memcg
Message-ID: <20261116195213.GF2452510@ziepe.ca>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-6-cui.tao@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106131829.3228926-6-cui.tao@linux.dev>

On Fri, Nov 06, 2026 at 09:18:27PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> IOMMUFD_CMD_HW_QUEUE_ALLOC pins up to max_npages pages just to check
> that a user supplied queue region is physically contiguous, and the
> page array for that check is plain GFP_KERNEL.  The size comes from
> cmd->length, a u64 that is only overflow checked, and the array is
> freed again as soon as the contiguity check fails, so the allocation
> can be repeated concurrently: a 1GB region costs about 2MB of
> uncharged memory per attempt.
> 
> Every other iommufd allocation that scales with user input is already
> charged, and the pinned pages charge the mapper at map time.  Charge
> this array like the rest.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  drivers/iommu/iommufd/viommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
