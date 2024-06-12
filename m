Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D3A129E64;
	Wed, 12 Jun 2024 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718228494; cv=none; b=TCsFylzJoDIZjuqg/FVC9RgOmDbnquqo+nL77bDW2H1GVgewsXstjmCaB8+Kcr2wqkQWI/ySCjIPD/42b1Qh1BjCvbZe8B7+UtlMJ6kmtX7Ghmfg/7qQy5cpZpvSJKlV/14dfxMO9eJ5SuBh7G24GT/k+nMfUZ7e+JC4oXBMl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718228494; c=relaxed/simple;
	bh=7x2FDvxcUC0zqmhJl7l18I4RbjqoDccV+BJoZyJQjCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iulaPd1PgXlVHoLW05XCAIYgWSZeFWU8Pn8N4FYMigOkyx6yShmE4JNve3VViE4s7DSP5pX10+9zBZC64qSq51rYAooif7LSEfhsXsAGPcG6OlafAMfCEkW0HE4MV26EsS8jbDpsXIWN6Oc8tYAdn8Oq4xZfB9j2bKUeUs0vq5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rqB2Doyn; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rqB2Doyn"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VzzWc1r0qz6Cnk9Y;
	Wed, 12 Jun 2024 21:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718228489; x=1720820490; bh=7x2FDvxcUC0zqmhJl7l18I4R
	bjqoDccV+BJoZyJQjCs=; b=rqB2Doyn0hywRAw/D3QbDlO7LAopyoiRAh4wa9iQ
	v2835DL8uaxGe2EOqRU91P3dJvxqZQfA1bgtEGeFQbKM/1lCOirv8JxKqwg3Kvsl
	0puzKOgsaQuLa86qP3+LUcA7m+PwyPtRR/SqnKMF6yoFqLDML20SMpcCD/dlrEH/
	F6diFvl77EMCW4F5AXPkSvpHIFmmp/DeI/l2+Oqw88us3AVk6fw/2UicbEK+m23N
	NqGrpAJcksrRqBH0Ud/WsbJgvaLrM9JbdKi1dWWQlH/6i+unLutS399KWa6/yDw7
	azF79WZs3vV3rxGJ5DF6VE7KOIH55ZBB5rSkVkDqf5OL8A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7DCoJq-qybHo; Wed, 12 Jun 2024 21:41:29 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VzzWX63qJz6Cnk9X;
	Wed, 12 Jun 2024 21:41:28 +0000 (UTC)
Message-ID: <48a000f5-ef66-43bc-b501-3ea7bca07c0c@acm.org>
Date: Wed, 12 Jun 2024 14:41:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Fix an incorrect comment
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
 Avri Altman <Avri.Altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240612203735.4108690-1-bvanassche@acm.org>
 <20240612203735.4108690-2-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240612203735.4108690-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/24 1:37 PM, Bart Van Assche wrote:
> The comment that scsi_static_device_list would go away was added more
> than 18 years ago. Today, that list is still there and a large number
> of additional entries have been added. This shows that this comment is
> incorrect. Hence fix that comment.

Please ignore this patch - this patch was already posted earlier today.

Thanks,

Bart.

