Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794861220;
	b=gw/TMa2Xh+aaXgLepmJ9cBZ3v7wrB/lrRwf7hvINLpS8wWgP8JEHKnPJ/D7+OtWd8nwc
	 hPCU/ImivllD4NpqjaXvtyzBBE+jDAkJZ1lm2t2BVfuSHx9X4wtStb8IzqvDsGgEGJJlE
	 dlBYS8MFdQ2GEcSCRgazrUuMPrMbLMg7CTRu+ALVeaYCmoG2dYOhqCjup9QBrazpx61oh
	 2OZOnMcBpFZENOON3fFv+KX8UGmGE4lJfQBka9NqHJ1QLAPD6N2q5s9Q5lBxbXIgGdCTZ
	 iwbrEbzlvwQnFO942SWJq55jqPl3dW2Q1BhLaYh01ssZjQwU94+8KIcaC+P/XzZr6OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794861220;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
	b=WN6TCmSO7QWwk8UYz5Evyq+kxHa/aMKC2WaCI0NXyHY7L6ERKbfdRKaKmmyMp1sCCsyw
	 C93CBizA8rrzgN20K+ob8P1PTJJUFt1w8cpPmAaMUVCyBQB+cqvxLMZS4JAGRJWLGMsIe
	 oE1fosXRvFt0TU9B9GVD/yJzlLhS9KPnIfUA0jcWBtXR2/Ji3t9FufEtE0TAbWHHz7xMm
	 7Pr8sH6wdZLXFFPIvxvnoK45Q16o3bDkeeLVkn6fTZoTX6KQdj5UVpVMYyc+IZqZHWRLi
	 dcrydome5DViQqA1TtEfuDWlnwJRUxpnKBM+y6OBrtZK9aFRZ3p4Ce8eTgICAFQPXjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=W8qlgedU;
	arc=none smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C277606A881
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 20:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C277606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=W8qlgedU
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-94965745d92so232702985a.2
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 12:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794861219; x=1795466019; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
        b=W8qlgedUXT2a/t6lhLP87IFTcy14JLKYa/mLodRolDlr9xZZQGxtW5Noy7E031dblU
         MZyTiD0CS6csrzNdM/y/kT9cZThOJzBfJnBjyuudT36134JK9rL5Y+cJlR9PkLw6In16
         I1GQFmpXC+GQjLACTJo0WVW99izKDBVRyEpioO38WVT6BB7yoB56iiO/mZo9HLJwUqYy
         WRepiT2m5sdFzS0WIaIky8pQ9PM9gsPwA3F1oZ8AlieRWNRm9qrQr3NdwmjMdkz0t3US
         NP5znb8aU6kvol1hpUX4T2gg8E0YcF+imIMZKWdgwp2eC1/JJZ5bvYf6eHZddNlll3GG
         nyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794861219; x=1795466019;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRUBObM4vFL1TGf3o6s1ZDBsKZdTJ/3jimI0MzXw8Fk=;
        b=dpEy59GDmShO7Gu+tPmF9EBPjsdYV6U/4Dlz8rNLPIILNduxcfWjeEhiRLFTmVG4x1
         Btr0zagkoPNHCu1iibWfhF1pb1tCBIflpo4J8ExFUXGosNzRvBu/ylQlmp1qMSj9/uWg
         SoWe8rdV1d3mOX8fl9VUCPmkYm+nLehbIm/R8hrdLYyOCDDxlreFfpbaWI86PJKIXwYb
         PkXnYRrldWCusYgoFA6W8DMjV46GdiE9J5c6kVpXDz44MHTNNVSfehsiIZH/pfQ+IfAd
         +nIF7fR8CVN30gn7BzGAp8TU1rx87/WGni7TSPEedyI3XKzgQpKjvSPzyJ/76hvPqTAH
         0Stg==
X-Forwarded-Encrypted: i=1; AL+hErEDH5+NHkjGOZl5qjuUDsnq2DgyPtRCljoyOZgqDr1bhZ5xVIs7Ke7zxyVdpsrP8d44rTX5UiZCXH5T@vger.kernel.org
X-Gm-Message-State: APuU4Z/jPzYzRvvdMTkMak6nu680wuSA/k1YRsKYvAT6itfuKP3NkbVm
	GwzKA6UJ5vZCDY5rpt7PEkodtxfynbhaLR0TnKadoGeJ8CnxvtrW8QpDX0YCMtcQU28=
X-Gm-Gg: AYBFou3e9sfYHZN4dihDxtXwqCBQgrGNQWCKcqKAcTU98zc76uq8gpQUemyizfL4L9N
	HYNJe6S0g8xOhE+K9a8IhAsqPoIONNDEzXZPHJ6svE+oeZrMUAfxUBeUFbp0BlpKJhsYbri3IR2
	0GAm0yvMFkt3B3dfRaVSTs3b9qkTWdTyvh/CYirkTyJEwJeofJpsV6L1aCCGivKnNlY0OsCrEJz
	WpuYGDxrp3rCDVIpkaB1By5+txr+swbdjKlsehD3+NX9RH5HR1ppCuONltX89sMjyKURdLyGHpj
	mmSsilCnJC8ISxvTl0XuSGEp6iZQv/vuL3/OHhNOPAYz7Ip2N4v9upSS5RSkWCntgmagNZQfnIq
	yIEtbScnQTqvfUJRBytyyF0DkD3KGQBZ/aoyUndtBaKMbww8uA88lSAszoVZx8nX0Yllrrhtiit
	oQHFBtugU4a8s3PDh7dOkBemWCdvf0a4aIWc1Ea5VKPrTkAGe+aFxStCOybMn6WjhI6DBSbEUhB
	YKN/RzD52fu/X4/QUrckYKZGskvdw5aMZke4yEiz1fScL6Hzg2odm7teBSMOJ98lP28cHKT/aWE
	wSO9mg==
X-Received: by 2002:a05:620a:46a6:b0:949:733e:ddd8 with SMTP id af79cd13be357-949733ee766mr1034555085a.54.1794861219140;
        Mon, 16 Nov 2026 12:33:39 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c804f9esm930800685a.11.2026.11.16.12.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:33:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xT3OT-0000000ARJs-2rZa;
	Mon, 16 Nov 2026 16:33:37 -0400
Date: Mon, 16 Nov 2026 16:33:37 -0400
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
Message-ID: <20261116203337.GA2481588@ziepe.ca>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-6-cui.tao@linux.dev>
 <20261116195213.GF2452510@ziepe.ca>
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
In-Reply-To: <20261116195213.GF2452510@ziepe.ca>

On Mon, Nov 16, 2026 at 03:52:13PM -0400, Jason Gunthorpe wrote:
> On Fri, Nov 06, 2026 at 09:18:27PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > IOMMUFD_CMD_HW_QUEUE_ALLOC pins up to max_npages pages just to check
> > that a user supplied queue region is physically contiguous, and the
> > page array for that check is plain GFP_KERNEL.  The size comes from
> > cmd->length, a u64 that is only overflow checked, and the array is
> > freed again as soon as the contiguity check fails, so the allocation
> > can be repeated concurrently: a 1GB region costs about 2MB of
> > uncharged memory per attempt.
> > 
> > Every other iommufd allocation that scales with user input is already
> > charged, and the pinned pages charge the mapper at map time.  Charge
> > this array like the rest.
> > 
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  drivers/iommu/iommufd/viommu.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I'll just apply it, thanks

Jason
