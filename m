Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DF117578
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 01:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753055; cv=none; b=AEDzYjnWUMM6NXU1i/FM4FhTJO3Sopsfwox0g13yyr/+N+AddmUIr42XOeGich2KXetNgm0ocI5TgmjVsTIqRojM1uHo88LjLSiW5Y7nm4S7l4XTcP4ZkCmVOkzhhn1kLfVu3Tq1pbtfOolV/gnv7ONAEFoD4AVNZEWStmmdB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753055; c=relaxed/simple;
	bh=KuuNpUp1Uz5Ktx33Qcr7x2qMPIIo3c8r6zUVA0ACiRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EbOk86dQiAcjsFRIXaa0+Yrw9RiaVoz73AbDK3tWlVZEzBzA+fYox/lR1HLgkE1ZQvqww0cDClA73lSKW1ZCuvHcm9VNqXsnsPXSUiKT0n7stCZMAJx68JUNdJqLVBMzq3fA9UGhW2ow3jllUcvh8bINCu/N1IXubqdEmzmEke8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=Q8pu4tIl; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="Q8pu4tIl"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id gRtUuHQyD3e9egZHRuIAwz; Tue, 29 Jul 2025 01:37:25 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id gZHQuHX4VwagsgZHQuyxLx; Tue, 29 Jul 2025 01:37:25 +0000
X-Authority-Analysis: v=2.4 cv=L6XWQPT8 c=1 sm=1 tr=0 ts=688825d5
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10
 a=WYIQ2lYssPUY7UsK-k4A:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5Oi/z+MH1e69H5RZADMOnRXyrgfixOxrKi0szbBVByc=; b=Q8pu4tIl+2Vm/eTl70DQfBsv7a
	jZCMZDnY8Qt6CJYkRtMQ+Mf9BsbIzoMWFhJORkZhcJCg30Wlv5n21tk/gsMEavSnKRlUJWTMAR2Im
	Lr2WJfmAu8NeKOZlt0E9XVzq2hQXNth9f5cgjKdUrVw0cJdO74ZPhTbDShiAJ4EapkEIy5eqKNg6U
	nNr/0wdDXNwlnyxNTZ7v+zvBaQsdejCJr1+2Qb5+v8Bjam88/9P2mALF6pH4fDMQr5ONqN9ujqxXP
	+AvJ06d5mgdPwdXBsNsVpeVkxxMeL4XmtXoydLKSerxSAoDTKTwGw3NDLBUQOXIm+4jCe7xgl2sQb
	LguzS+PA==;
Received: from [177.238.16.239] (port=47150 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ugZHP-00000003PRe-2j8u;
	Mon, 28 Jul 2025 20:37:24 -0500
Message-ID: <f9525216-5721-4f9e-99ab-d697506e0e8f@embeddedor.com>
Date: Mon, 28 Jul 2025 19:37:05 -0600
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
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
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
X-Exim-ID: 1ugZHP-00000003PRe-2j8u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:47150
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNwagpA0KlNFayJV+DslZnc4Dy30Asgap42I8n29NQx0WPf5q5lrAIeYW018CW1MngME0LvuQsHXGNOl+sndOzKjPqHOTsOhD9KF1C5TKsU8RmsAffQP
 HqRgWDEEkmJRNs5ao2ByzCsdRi/48WxlRwMFzLwIkUYjtbZVF77vGxF/ldtmB8pmLPXzACC6Rn7Mctz7AEO2NNS6y7OZErlty2teojkFVp3JOLNOf3rySxS3


> default item was replaced with the header and a static sized array,
> cast to a purex_item * when returned through the alloc function
> 
>    -       struct purex_item default_item;
>    +       struct purex_item_hdr default_item;
>    +       uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];

I see; yeah, this works as `(struct purex_item *)default_item->iocb`
and `__default_item_iocb` happen to be just perfectly aligned. However,
I wonder if there is any chance of this changing in the future...

Probably, a code comment stating that both `(struct purex_item *)default_item->iocb`
and `__default_item_iocb` are expected to share the same address would
likely be helpful for anyone modifying something around this code in
the future.

BTW, instead of directly casting to `struct purex_item *`, you could
use `container_of()` like this:

item = container_of(&vha->default_item, struct purex_item, __hdr);

but I guess that's up to maintainer's preference.

Thanks
-Gustavo
