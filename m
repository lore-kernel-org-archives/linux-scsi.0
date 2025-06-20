Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E42A1DD543
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jun 2025 16:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750436364; cv=none; b=NMZuk5PnozEIvdsCXxT2h2CYpBaOwypcU1HvZ02VZ579z0iuUrK7h9KJEKVeI0Uah9D78x8eW/4FMiSV24SxCe3M/n2i8E/2BFTeUEppFHNujpF2OjTILGX9JmmPbe5+TUzdr9HLHnxLMR5PqGpyP3JWDBYrxkrm1SB2Ag3FZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750436364; c=relaxed/simple;
	bh=hHrrSotckrhS7tnNGg7ikgX/D3nBFxAz/7xxKpbxtN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GPB0AgeryxtZ0ituWGP/CyzdoMlvbC5n+TmkAJGyOoZz3GRC50hqoprIswYv2Wwdv0Ky0DU0HlYKXOuO5c9gpQ3Ort6Om/qZ2GpH9F8jxXHZgHs5IENWPoixhd7JMp0ZWvldBpE7H8T2QQNz/dAcq17iXYfd6b8jT2E5/pBd8EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kWlWsTkU; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kWlWsTkU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=DsOOHo/Zxfis0r3VA+UrPpUChLyhjkBZC5HH3DNlCeE=; b=kWlWsTkUFR4JMqioXPAiwN9mML
	X/AuFCAaI0Bf1EdEVwIoywOjnFqBJotgWBu+RgWsogSmnL5fKkYWcB6DsQXyncdlf7tKhRP0SaG1q
	7sj5WVvm+Cq9kg57Ct6n1KW2pQT1c98bCA9W1K2+l4OQEEsWGXKckqefua4bOXZu8w/EFGJHWuuXd
	T7OH5uOpvZyt5njDZeKPnGCPkXU/Xj3YxVLs37Io5BDgq5gQNhPk10q7idPzvThSD8d0r7uDWYAub
	4K/KPajKvlALG2hPm4MMh5orlUOw2qYV/Imlmvj8eMFoBinToyW0ClrobiB9IMNES551n3b3tA3c7
	Vs30zvBg==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uSeSW-0000000D4DE-034n;
	Fri, 20 Jun 2025 16:19:20 +0000
Message-ID: <32632866-d0cd-451d-b572-fbc13eb3c88b@infradead.org>
Date: Fri, 20 Jun 2025 09:19:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: fix kernel-doc issues in mpi3mr_app.c
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, mpi3mr-linuxdrv.pdl@broadcom.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250620065628.3348589-1-rdunlap@infradead.org>
 <f2b0e569-1335-430c-8147-9179caced2a4@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <f2b0e569-1335-430c-8147-9179caced2a4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/20/25 12:16 AM, Damien Le Moal wrote:
> On 6/20/25 15:56, Randy Dunlap wrote:
>> Fix all kernel-doc problems in mpi3mr_app.c:
>>
>> mpi3mr_app.c:809: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_hdb'
>> mpi3mr_app.c:836: warning: Excess function parameter 'data' description in 'mpi3mr_set_trigger_data_in_all_hdb'
>> mpi3mr_app.c:3395: warning: No description found for return value of 'sas_ncq_prio_supported_show'
>> mpi3mr_app.c:3413: warning: No description found for return value of 'sas_ncq_prio_enable_show'
>>
>> Fixes: scsi: mpi3mr: HDB allocation and posting for hardware and firmware buffers ("X")
> 
> Missing the commit ID here and the patch title should be enclosed in ("").

argh, user error. :(

>> Fixes: d8d08d1638ce ("scsi: mpi3mr: Trigger support")
>> Fixes: 90e6f08915ec ("scsi: mpi3mr: Fix ATA NCQ priority support")
>>
> 
> I do not think that you need the blank line her

ack.

>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
>> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
>> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
>> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
>> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> With these nits fixed, looks good to me.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Thanks.

-- 
~Randy

