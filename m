Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D7E2F60B4;
	Wed, 22 Oct 2025 19:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761161977; cv=none; b=EVzhJNWczZP0cVv8PAekbBk62EJLS1xn1AiaWND1+3Vk7GheguQJloBczv6dp+DtV00Y2XyE6YQOhB+DYImi3rKxLhCFnAtJWmntR1YQYTjSY6pyucVAZRu6VfcQZjF4YuCc0d8BQGjUAhiIBknVqv2JzQMOLDGROqLdaJIhdfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761161977; c=relaxed/simple;
	bh=OGwpRsjvTDh92mjiJpGpeoAWI6QfFFqssvTioP35C0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tAK2wKVkzP+yL+jO+YS5OqIrKLs7B+u3UexC3AoEWMzPHL5f+0o8Rp8IL0kDAX34qOr1WmGknKhEUlhQ0iRoet5XGjeiQNdJCbbAJHiwr7vbmDnIPfXAVlWFwTzXDUAQ9n973NkoZiH8xoQtahecvD2a/YVUwuYE2Trp0C0QSSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bDEdI38B; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bDEdI38B"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4csKHV6YwKzlgqW0;
	Wed, 22 Oct 2025 19:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761161972; x=1763753973; bh=CI9hnY04nrya/ShYHIvwuner
	OYGmjYVhaHBWLNcFY3A=; b=bDEdI38BTXK75OcE1DTccaWlgOXddxn/SYLvx61j
	hG92gcsemop8pgQqFIpRor9sUaBL4T1tuZLjh8bqdY6BNPeeMJxWU0cvIJYEIUUQ
	LVRg/CN7mMFdGOzwzgwEarCkC0ukq7m867XVpwGzhz3bmCsvNMp03us3IG0BXHdg
	AgCDhdgBQzHVAnY00iMnkKJtYYMnpKnnRqlCcOoXARvQVvcjPJTgWtEFMaZq2tEq
	OcARm9RaVP7VzwG5vWoMAzRqixWNOaaEgComWcYCuam1P7ff+8jOBgeFqQhtbX05
	O9TgBxah9WjgIldVHy5q7uKKFYD8QPyvm+53kT27ocH5IQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8FkmcuAYkN1W; Wed, 22 Oct 2025 19:39:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4csKHF15XrzlgqVG;
	Wed, 22 Oct 2025 19:39:20 +0000 (UTC)
Message-ID: <1d02a30b-1450-459c-a4f4-ae795d7dcb27@acm.org>
Date: Wed, 22 Oct 2025 12:39:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] ufs: Add support for AMD Versal Gen2 UFS
To: Ajay Neeli <ajay.neeli@amd.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, pedrom.sousa@synopsys.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, git@amd.com, michal.simek@amd.com,
 srinivas.goud@amd.com, radhey.shyam.pandey@amd.com
References: <20251021113003.13650-1-ajay.neeli@amd.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251021113003.13650-1-ajay.neeli@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 4:29 AM, Ajay Neeli wrote:
>    Removed patch that utilized reserved bits for vendor-specific interrupts.

Thanks! This second version of this patch series looks good to me.

Bart.
