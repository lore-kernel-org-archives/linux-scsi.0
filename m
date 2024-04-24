Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DF8153504
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 07:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713944857; cv=none; b=MnulsBL9Eefp+t6+uTEx9M+ieDUAg2VMimSWcnNU95lPjOEJ/mrD0NyiywP2lpULOfyXRbqYNfIBG5K3QlK59GNxdsIJUcPCpLeIhUf2fHCY55I7DNke6sPkcVtvActd7nr1++sOXa/ZNKPfUxPQQgQeclBQW3Zumz8Svp52uxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713944857; c=relaxed/simple;
	bh=GwfYEtEdorBv1h6qCWcbEOayFQW1OqjHWYypzeMXDfw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=ixitHeLvUqOPJ89lQp9A8LpWQby3yp3BwQD7UuvUx3coenfkw+e+Csk34UQ+Aep7NfCKh+MhDpnRsFXVuJOsdU5khOpLy+TLznrR8tz+g3mxlW8zxOjAUqcVHtunvx18u6jXgTJuSNJSo1TDySxHCjuKdT+zwXPwe2aI9DUX5ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz1t1713944840trc2j3m
X-QQ-Originating-IP: 0IcKWWtPfJaTPjsu0R4YZ6vrySQZ3E1liW8gGvkGKsI=
Received: from winn-pc ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with SMTP id 0
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 15:47:18 +0800 (CST)
X-QQ-SSF: 01400000000000I0I000000A0000000
X-QQ-FEAT: HPkwb3INVpAGiWRfmby7PFE/Qgq/fD7U9q8QZJgNiBVWvizLSP22YH1zRC6+I
	UvpjpqHVKBtrKCWUwp9d92rUqL+1rj0rX1ToFHi4KIXfbeSrZ2g8mlqH4Za394Xf4uV+8Zl
	f5vbH+/gKlTdXsUWgAcdZfzAUdMZ/QU8TCLouCrVeoibz6IxMtZ+z1OrypiCPszX4gkg/Bm
	aEAVjRQDJfEjSE+btf89ibO2H9IfQkuOwrf+0of+kJV4B4YV0b1IAKwuD15N9bpZixcvaNK
	4FTH/oCC740wkJzeEuDebnhCwt1MDBK5qYmA65EmEdO4LlNcB6T0DoZB5d6JdUaawHMFHVb
	yqKupWh5/RJ+enO65n1Yw7unZfT9fUNNYjU79KfNpz9rbWIGWnwpGc8+ydj1A==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1879610637823835156
Date: Wed, 24 Apr 2024 15:47:18 +0800
From: Winston Wen <wentao@uniontech.com>
To: linux-scsi@vger.kernel.org
Subject: unsafe shutdown during system restart
Message-ID: <482E2895A2BA14A6+20240424154718.47b5976d@winn-pc>
Organization: Uniontech
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1

Hi,

I noticed that my hard drive had an unsafe shutdown during system
restart. I have done some related research and found that a stop
command will be sent to the hard drive during system shutdown, but
not during system restart. 

Is there a way to avoid the unsafe shutdown? Or is it the
responsibility of the firmware to send the stop command to the hard
drive before shutdown? 

And why doesn't the kernel send the stop command in system restart? I
am indeed curious about it, and I would greatly appreciate it if anyone
could help me clarify it. :)

Thanks!

-- 
Thanks,
Winston

