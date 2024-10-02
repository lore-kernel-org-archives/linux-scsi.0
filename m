Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EEA1A01B0
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727912826; cv=none; b=R3Do4XfN5abN4jlFqS4/Ic8AJwwBywzIwlqjLzJ3LE+F9NwPr9ZglUsRjoh8eYkTGjb+XhjRhalUV4BccZHBNYDEBwdODxpkrcwsn+MaEhsUnm3C/F0UTyW+MoKtaCXK6Y8z2wZHVLpJbjj1PHHlwTm6t7BSrGm3W1UnfvuLuPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727912826; c=relaxed/simple;
	bh=orsD4QUPWeVpyu7yNLnjAhXHyStdn6MJBuL6EyNqvvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0EzYmdecPc3pGBKYT7jTeH0RBKjfVl8oEpZEhG//4rz7QYBmi/F5/8oyQceLs2nb5OOWMQZPFGP+GBqmqHlvCk46D8IH2a3omRR914pKbknhCDIio5rmitoSJaRv2y0kyLgsSuK4nXqH4SCRT2OEqPu7MSUjgL9yFZctGn4cuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1aVDw+fC; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1aVDw+fC"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJs0m4T3KzlgMWH;
	Wed,  2 Oct 2024 23:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727912823; x=1730504824; bh=J28NJ9B3pNki9pXMsXrj5FTj
	7I1yHbikJOzIUEFKBuc=; b=1aVDw+fC8HYZjKXYysUr6Kzymn7lBm6KLwiwbMj1
	mveFHRNgxvgSTFONa6TCuYcltYeL4+0yieEuufqcB36VOU/8H+p97SxgBR0ZExCf
	nxJHrvjvCnaqcE4EXxzL3fovdkLLS9Xxew6oXaTq9+5UW9wQy8neTv+WS6om/yUT
	hx0rbHJFEH10e+1vYLKGJ+wOyiw+7j9dQlBDPfY4RXu7QZjHW4qm/SLx9ENqPPIC
	PvjCN0zzWLCKPpkrqIAbkWGgdoa85BTN2ialGRVdtqyZV49hTHYJLdKjLiA7E/3i
	cA2rUAC0y6PDBakFmd9W2XrSSdWljVGbF7ey2n8d50Y8ug==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m80MTowPNrPy; Wed,  2 Oct 2024 23:47:03 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJs0k0ZnhzlgMWG;
	Wed,  2 Oct 2024 23:47:01 +0000 (UTC)
Message-ID: <be346e1f-eb50-4561-9319-7554d7793785@acm.org>
Date: Wed, 2 Oct 2024 16:47:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] scsi: arcmsr: Remove the changelog
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-2-bvanassche@acm.org>
 <a81e712d44ddfcdb87897d3b988632df11797801.camel@HansenPartnership.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a81e712d44ddfcdb87897d3b988632df11797801.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 3:39 PM, James Bottomley wrote:
> On Wed, 2024-10-02 at 13:33 -0700, Bart Van Assche wrote:
>> Since we typically do not maintain changelogs as text files in the
>> kernel, and since the arcmsr changelog has not been updated since
>> 2008, remove it.
> 
> This is legally problematic.  Under the terms of the GPL, the
> copyrights and change log are required to be kept intact (section 1
> since they're notices).  We sometimes fudge around this if there's an
> equivalent in the source control system (so the git history substitutes
> for the requirement to add change notices and can sometimes be used to
> remove change notices if they can also be seen in git).  There isn't an
> equivalent in this case since the change log pre-dates the driver
> addition.

Hi James,

Thanks for the feedback. I will drop the patches that remove change
logs.

Bart.

