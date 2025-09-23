Received: from jupiter.guys.cyano.uk (jupiter.guys.cyano.uk [45.63.120.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA6010F1;
	Tue, 23 Sep 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.63.120.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758634300; cv=none; b=omPL4XBFXoQ1czwgHIKXHqUCuB6ZfYvQKiWpV895FDm5nf+croXiGEHXaeVLcZpHiXTKpF7IGcSP1NFmbsxfkLUcCNq4EPy1owANHsfZ2fkax8ZbsMCkEZCenQik/pN8RLtQi7nODERpMF6ffzg/fJwW8kIO/bsiy3y5Mtco3G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758634300; c=relaxed/simple;
	bh=j8byVeNX4TQDtD8QbMaEXYgRd9Te2VgWLANoo2ZQ9hw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KzfM1oqdqVSp6GLJf7uDxy0y2Vto3Pba+lVuzLE4XLukfCM0guboLpoptEtYkFKL3beBY/zI4hu3tlM4oMrVNmzT7HLqfLaTIp5VkSS7Ui/Wq5IQ/NXJjmxHC1cAfyeljxzsdnbIqSPra9Co5km/m91IOZLBnbsW/uak/YyIAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk; spf=pass smtp.mailfrom=cyano.uk; dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b=qQCQCnXk; arc=none smtp.client-ip=45.63.120.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cyano.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyano.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyano.uk header.i=@cyano.uk header.b="qQCQCnXk"
Message-ID: <c6a39939-b0cd-43a3-8b63-114909ba001e@cyano.uk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyano.uk; s=dkim;
	t=1758634297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlHpoIc6rMZqw0AZAsMkpyzs1nRv311zogcg+1Ko7i0=;
	b=qQCQCnXkmXrE+HuC0wm2a0HeW5ioyMr4DLtjCpOQACNfRQCdNQoT+cuL9zS77/8vtoD7kG
	7ARed9W19B/P3q4oa0SM724PIo/C1fyALocDzLjmFtO/xGIh6b/VlPtY8LvQgpk3Sf3xEu
	WYcWrRrehOvtuEZABd1QnVp3TPb9POSBrDsdAjoOAoXSMp2KYcsrY8StZHoLPwqOd3+r5u
	1J+q0LW5eQuBO8CEtANYkfCFri3HAI8BlkwSRvBuObPxhksBJgRvIKYH3hXe1WYSllIw3y
	j4666uuJ7H24o3ao5o+P+2RVSc3LSGV4oupn+RLUju20UjuFgv5EIO5+DW0zXg==
Authentication-Results: jupiter.guys.cyano.uk;
	auth=pass smtp.mailfrom=cyan@cyano.uk
Date: Tue, 23 Sep 2025 21:31:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/2] scsi: dc395x: improve code formatting for the
 macros
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Mingcong Bai <jeffbai@aosc.io>,
 Kexy Biscuit <kexybiscuit@aosc.io>, Oliver Neukum <oliver@neukum.org>,
 Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20250923125226.1883391-1-cyan@cyano.uk>
 <20250923125226.1883391-3-cyan@cyano.uk>
 <1ae97d061da14b0d85c0938c3000ed57ccd39382.camel@HansenPartnership.com>
Content-Language: en-US
From: Xinhui Yang <cyan@cyano.uk>
In-Reply-To: <1ae97d061da14b0d85c0938c3000ed57ccd39382.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: /

Hi James,

在 2025/9/23 21:09, James Bottomley 写道:
> On Tue, 2025-09-23 at 20:52 +0800, Xinhui Yang wrote:
>> These DC395x_* macros does not have white spaces around their
>> arguments,
>> thus checkpatch.pl throws an error for each change in the macros.
>>
>> Also, there are no surrounding parentheses in the expressions for the
>> read and write macros, which checkpatch.pl also complained about.
>>
>> This patch does only formatting improvements to make the macro
>> definitions align with the previous patch.
>>
>> Signed-off-by: Xinhui Yang <cyan@cyano.uk>
>> ---
>>  drivers/scsi/dc395x.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
>> index aed4f21e8143..cff6fa20e53c 100644
>> --- a/drivers/scsi/dc395x.c
>> +++ b/drivers/scsi/dc395x.c
>> @@ -91,8 +91,8 @@
>>  #endif
>>  
>>  
>> -#define
>> DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock,flags)
>> -#define
>> DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host*)dev)->host_lock,flags)
>> +#define DC395x_LOCK_IO(dev,
>> flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
>> +#define DC395x_UNLOCK_IO(dev,
>> flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
>>  
>>  /*
>>   * read operations that may trigger side effects in the hardware,
>> @@ -100,12 +100,12 @@
>>   */
>>  #define DC395x_peek8(acb, address)		((void)(inb(acb-
>>> io_port_base + (address))))
>>  /* normal read write operations goes here. */
>> -#define DC395x_read8(acb,address)		(u8)(inb(acb-
>>> io_port_base + (address)))
>> -#define DC395x_read16(acb,address)		(u16)(inw(acb-
>>> io_port_base + (address)))
>> -#define DC395x_read32(acb,address)		(u32)(inl(acb-
>>> io_port_base + (address)))
>> -#define DC395x_write8(acb,address,value)	outb((value), acb-
>>> io_port_base + (address))
>> -#define DC395x_write16(acb,address,value)	outw((value), acb-
>>> io_port_base + (address))
>> -#define DC395x_write32(acb,address,value)	outl((value), acb-
>>> io_port_base + (address))
>> +#define DC395x_read8(acb, address)		((u8)    (inb(acb-
>>> io_port_base + (address))))
>> +#define DC395x_read16(acb, address)		((u16)   (inw(acb-
>>> io_port_base + (address))))
>> +#define DC395x_read32(acb, address)		((u32)   (inl(acb-
>>> io_port_base + (address))))
> 
> This doesn't look right.  The problem checkpatch is complaining about
> is surely that the cast makes it a compound statement.  However, since
> inb inw and inl all return the types they're being cast to the correct
> solution is surely to remove the cast making these single statements
> that don't need parentheses.

Thanks, I checked the definitions and you are right - these read macros
should have their casts removed, as they now return u8, u16 and u32
respectively.

>> +#define DC395x_write8(acb, address, value)	(outb((value), acb-
>>> io_port_base + (address)))
>> +#define DC395x_write16(acb, address, value)	(outw((value), acb-
>>> io_port_base + (address)))
>> +#define DC395x_write32(acb, address, value)	(outl((value), acb-
>>> io_port_base + (address)))
> 
> And these are single statements which shouldn't need parentheses.  Are
> you sure checkpatch is complaining about this, because if it is then
> checkpatch needs fixing.

Thanks for pointing this out, they don't need additional parentheses.

> Regards,
> 
> James
> 

Thanks,
Xinhui


