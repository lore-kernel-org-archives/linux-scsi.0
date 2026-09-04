Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26EE3F9F25;
	Fri,  4 Sep 2026 04:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788496885; cv=none; b=FGHXF9OxRsnKwhKxecE4mXLItsiOSSDQ/PVqZ44gsPdLcY7l7Vgb1N1x/HvAnhQHsJFPsxVhXAX1hXBapgI+8ifrKwQJBlHwg+bmjV/AQXN59CaO6PIxf8hzOjXiEDsDUhKSu8+kP47malfkLLDwWTv4dWWu1z1xz3LD1/9CanU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788496885; c=relaxed/simple;
	bh=llAtHsLriXJzC9OnOV+JqrX1essYhJjrhQvJOA21glo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qqU0hEhHhgRUPpun47ia1VGd7O/hQgOZKg2yGuDsi2g2n5E0DWj+yEVNrQTIWghTv5DsVyZjZlD7mKGEI6lEi/fNh4eHARMYX28bWO8k2Fcuop2+tfGszk+WcPM6bLOvZ67qNL6Y2iFwOEBzB2c53HIMnilgo4Z8jm9QE2RN3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHk45O2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHk45O2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE6E1F00A3F;
	Fri,  4 Sep 2026 04:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788496884;
	bh=1mSFna2u6qrY3ph2bSCZ5emhiSk2CXZ5VVYOZm3Yyp8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lHk45O2KaKl2def1rT5c5TctHM+AhpIORxx5WbV6XuuYtvNHAtYfkqaCJ9ABP56mE
	 LgYzrv4lR7QskGGBV9OGbv/VrfyH/YsWusIA7blYJX/mGhZI6fYu6+7exW9uDX+OE6
	 xbMJAmwhfeDFx+rDLH1/mRkOqBc/XObamaT+y9Rc9h8qd7dF17MfZW0Y1r3C4VC7qu
	 0KwjyptpmYitHCilETwsVINU5zs56UvhQE9PESmKu/4EhF2S9WLtceMXlljhkl9PRL
	 cb7WKkFEKbaAcP4+OvR8Pwj7I/csg/COTVFUkIEHTIJcZDFyZNg2Qv/sZDMeyPxGxD
	 HnprdIU/WnOkg==
Message-ID: <d4bd2363-48d4-4fe9-838d-7ef4a0f4e0e0@kernel.org>
Date: Fri, 4 Sep 2026 13:41:20 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] scsi: Initial commit of VirtIO PCIe Endpoint Driver
To: Alistair Francis <Alistair.Francis@wdc.com>,
 "mani@kernel.org" <mani@kernel.org>, "cassel@kernel.org" <cassel@kernel.org>
Cc: "alistair23@gmail.com" <alistair23@gmail.com>,
 "jasowangio@gmail.com" <jasowangio@gmail.com>,
 "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "den@valinux.co.jp" <den@valinux.co.jp>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "eperezma@redhat.com" <eperezma@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Frank.Li@kernel.org" <Frank.Li@kernel.org>, "mie@igel.co.jp"
 <mie@igel.co.jp>, "mkp@kernel.org" <mkp@kernel.org>,
 "mst@redhat.com" <mst@redhat.com>,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 "kishon@kernel.org" <kishon@kernel.org>
References: <20260901014650.2728658-1-alistair.francis@wdc.com>
 <apaOZeeDBIRlpB7b@ryzen>
 <akvzpivrbg3b3jra6ibga6j637pwqkwnnzs6q2ymcn5ixrdym6@wniqpspkcknt>
 <795ac93a-9377-4503-9dc4-58f21c815f71@kernel.org>
 <2daeb43d582f0d960370fcd415c3b5bd3d94c67c.camel@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <2daeb43d582f0d960370fcd415c3b5bd3d94c67c.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 12:19, Alistair Francis wrote:
>>> Most of these pain points will go away if you use virtio-msg [1]
>>> transport
>>> instead of the virtio-pci transport. Using the virtio-pci transport
>>> on a real
>>> PCIe device without a way to trap and emulate the config space
>>> requests will
>>> always be racy.
>>
>> There is nothing inherently racy about the config space. It is about
>> the fact
>> that most PCI endpoint controllers:
>> 1) Do not raise an interrupt when PCI BARs or config space is written
>> by the
>> host RC, and
>> 2) All PCI endpoint controllers that Linux supports do not allow
>> drivers to
>> create extended capabilities in the config space that can then be
>> emulated in
>> the endpoint driver (enabling that would require 1 to be supported,
>> obviously).
>>
>> (2) can be delt with quirks. Not great, but simple enough. And in
>> this case, we
>> need it more because of the virtio-pci specs, which are not great to
>> start with.
>>
>> And for (1), the only real problem that causes is that an endpoint
>> driver needs
>> to poll PCI BARs/submission queues to see if the host issued
>> commands. Again not
>> great, but that works just fine. Alistair's point about burning a CPU
>> doing that
>> is simply so that we can reduce command latency and get good enough
>> performance.
> 
> It is actually racy. If we don't burn a CPU to check we end up racing,
> with the host as we are too slow to update the config space.

How come ? At least for nvme, it does not matter how slow the endpoint is to
pull commands from the SQ: if the SQ becomes full, the host just stops
submitting. There is no race. I would expect virtio-pci/scsi to have a similar
race-safe protocol mechanism. If there is indeed a race, then we are talking
about a deficiency of the protocols rather than the transport.

-- 
Damien Le Moal
Western Digital Research
