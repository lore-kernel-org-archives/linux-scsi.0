Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51AD15E96
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 01:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753839215; cv=none; b=ncXugtnWcKw+7kd5DEytJNz+CwyEf+ijI6pXKg9r4JMHJHjMAJysdlR4QweibxoBDe/07cWulwvXow4aKPRw7Kog2Gmoe9rd3CQN2oU7EIbXulgQ539M87NERvlfmta9xeFpr9AGz/gpB/wnZrN9caUkpg8RjPj5tF6ndk0ryCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753839215; c=relaxed/simple;
	bh=vMSizO2VEpZwGq+B9UPWKjnyiVJrwZS3etbpK1ke+v4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nPBfHdIawZ9nCe2tKVAofTK22QvZhw59VEvKyys7nyORguheSXkMKOY0FAAP/cLx5AjWxNahwOhsCwevwZlPD8Cb0m7V2CN25dPD2+i7hKc419H1go23iOZfXI0Eu9TTH4H6utV+PY6mBOhu9Ar7v6s76ZGcI05imJpUIjU56As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=lsCv3Tuf; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="lsCv3Tuf"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id gqUWukPnB1jt6gvh8ukeCl; Wed, 30 Jul 2025 01:33:27 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id gvh8uiScYNbOpgvh8uw1gk; Wed, 30 Jul 2025 01:33:26 +0000
X-Authority-Analysis: v=2.4 cv=Ib6BW3qa c=1 sm=1 tr=0 ts=68897666
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10
 a=Kf4hMXhTTlK3_wlT3WcA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jPjT42/yncGVYQIwqYgOjI8rH73xTvKQIV7k64JXcHc=; b=lsCv3TufQM/+3nVdt/V/y+b8jm
	f6KKM/LTkgdsEFHVOKjuzZi2CQzYNsrz6XWowDl7nQLxrwkzSxxChfySbbL14Le7LjUwiQkAKQmy+
	/ejJ/GXkFBnHAJBw7OHZ4cRuTpGJfQ4ldUivMhrDLzhT1+bvvYXHRiyTPft15dSraD24FVnqtGePE
	U77i2HWcb7yIwww31k17mU0GnMHW9GvxcomD7k0ecxTMswQVyZypQNYe31ieRuaZnZd2TwGMd3EUV
	3Z+YLHsmN+pwYXpHh/iP/40uSEZUcEbTftant1nKcjLBesSyHi5h9fzhwpayY1MPR0kq3xgBdMAOy
	YxPz6ztw==;
Received: from [177.238.16.239] (port=40956 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ugvh7-00000001Sx5-0kxJ;
	Tue, 29 Jul 2025 20:33:25 -0500
Message-ID: <f5d54a9d-db38-425c-8e1f-b213cc83ad5e@embeddedor.com>
Date: Tue, 29 Jul 2025 19:33:15 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
To: Chris Leech <cleech@redhat.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
 Kees Cook <kees@kernel.org>, Bryan Gurney <bgurney@redhat.com>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
 <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
 <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
 <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
 <f9525216-5721-4f9e-99ab-d697506e0e8f@embeddedor.com>
 <6d8f13c8-405f-4fa0-ad23-09c9e4c5cd54@embeddedor.com>
 <aIlhqnjTI_7K-Iws@my-developer-toolbox-latest>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aIlhqnjTI_7K-Iws@my-developer-toolbox-latest>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.239
X-Source-L: No
X-Exim-ID: 1ugvh7-00000001Sx5-0kxJ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:40956
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNlvPD57PfsK5IiKk92mF6uj36AONNCS+Jj8Dw++cMX0mYxcWsXVWHBdAdyf+q9oo1l/v7qoMNRPF33Ugc2hCiLoUGkNJeqioP/sM2sp3npaXm+vdUoI
 8Bg6u1C3SGXYOMHkff2dR4G/+VFd4nEox9LVZNAoYpDzUH90tsPkkxfYGIx3w/K27P1XCy+fFEye0EwiSvKTpXaHIgq++q1M4b5DuRYxuIJz4xr7ibVJkd+W



On 29/07/25 18:04, Chris Leech wrote:
> On Mon, Jul 28, 2025 at 08:20:12PM -0600, Gustavo A. R. Silva wrote:
>>
>> I just noticed that the new TRAILING_OVERLAP() helper just landed in
>> Linus' tree, and this issue seems to be a perfect candidate for it.
>>
>> The (untested) patch below avoids the use of `struct_group_tagged()`
>> and the casts to `struct purex_item *`:
> 
> (I was largely basing my use of struct_group on your blog post from a
> few month back, but now there's another new macro!)

Yep, the kernel is constantly evolving. :)

I'm actually writing a follow up post (and a presentation for OSSEU)
where I'll share updates on enabling -Wflex-array-member-not-at-end,
including details about this new helper.

> 
> Yes, that looks like it would work as long as the driver maintainer
> doesn't object to moving that field around in scsi_qla_host.
> 
> I'm getting ready to be away from the computer for a week, so I have to
> leave this for now. Maybe Nilesh has an opinion?

No worries, I can take it up from here.

Thanks!
-Gustavo

