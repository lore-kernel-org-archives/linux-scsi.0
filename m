Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F22270ECF
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 17:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739900994; cv=none; b=qdiITZbyEjpcFzyX89DLDxYiQ9LtIDZqaiUWpUS0/62b21vq6a6Voga63cImColr9a0jmlZxwLLnkRm7cpW2KVR+C2I6wSDCdtnlzsx3S7hLg2+vVzn35xaiTw7kpCMirlOCk1KPYnXTBBzc0Rq/FrdnYwgLEVYb29DZmjC1pvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739900994; c=relaxed/simple;
	bh=eMvVeQSQK6edeh66Y4MdNLLCB5hF6xDgOGq3KYBsxv8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kYDQN+7fK6/SUd9fpCpWo7Ia4zMo8yTv3SJAbBl/r/hjR0rYSry6XnK2dPEb7Yk+fMi3r6rkv0NpQNdBMT+onl1U6U9tTocLGbNXm5LK301IrKzhzZQPNsUY0z3Z5bbIa5P9OS1mu78ddorXOomVdMz1zQo+7CdHIz43SRFR/a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Krd9A8CZ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Krd9A8CZ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Yy6Q91wC3zm0ytf;
	Tue, 18 Feb 2025 17:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739900767; x=1742492768; bh=eMvVeQSQK6edeh66Y4MdNLLC
	B5hF6xDgOGq3KYBsxv8=; b=Krd9A8CZ2VvGL7nNsCYKwOypKRAVeS66P2Njw+g3
	9EWCe8o+IVNjVydyZy1KN8Bn3CWzDrR72m8mWwaUeJzl301g+VOGKpsX+7ZvScfE
	o+MRTlSnrabXa3zIo4Xn16BHBubeOCbF/lZpukPUn0onQC9xbR48bElc2jEHs6Vx
	u+UcM/FrVwA8K9t2MESzxFEGZ97GufbhZWhsk29jZ6Pitp+SG9/sjdXQJ6cVgiKR
	5cUZAkvAyrZb8tkOYCui52UPBAvvOeGrmV3jvfMDbDzo9OmvUoLeAIPxLuxkCmu8
	vlJZDao9loZLTedtoOculhHaln9FQbqO3JFeK56oSxnrpw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E6N3iheoRNxC; Tue, 18 Feb 2025 17:46:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Yy6Pw75Nwzm0ySk;
	Tue, 18 Feb 2025 17:45:55 +0000 (UTC)
Message-ID: <97e63f93-1bec-4757-b7de-35f23b12279f@acm.org>
Date: Tue, 18 Feb 2025 09:45:54 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smartpqi: update copyright to 2025
To: Don Brace <don.brace@microchip.com>, scott.teel@microchip.com,
 scott.benesh@microchip.com, gerry.morong@microchip.com,
 mahesh.rajashekhara@microchip.com, mike.mcgowen@microchip.com,
 murthy.bhat@microchip.com, kumar.meiyappan@microchip.com,
 jeremy.reeves@microchip.com, hch@infradead.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 joseph.szczypek@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org
References: <20250218163410.874309-1-don.brace@microchip.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250218163410.874309-1-don.brace@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 8:34 AM, Don Brace wrote:
> Align Microchip copyright to current year.

I can't find any changes from Microchip in the smartpqi driver that have
been made this year. Did I perhaps overlook something? If not, the
copyright year should not be modified.

Bart.
