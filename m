Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0F93D7D85;
	Wed, 25 Feb 2026 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772037015; cv=none; b=SRS0xK/24x6VV7b5PqjaBYOTnuFsMnrVWRBryYs4DzSNHPle8JY8CQRQf1Hi1XkqDZ1/fJ5/oCx4KFLddJ0EnKu9Z01YNgHp6ejlqiahRLiKlMUYedvKV6wa5FxAjH1qs5wNO6uWewilt+6R9O6Fd7fV3XwdcxgnOiqwYEVRkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772037015; c=relaxed/simple;
	bh=vJ804UQQ83e2Rnv1VzpHVArw1fg05t5j1rsobVSyUnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NCbap3Gr5XCfB5xEL+y/uW4IJmeqV0XLzJzAtt/HZ7py5BzTsc0ia04w6av2h0x9rDqOJohM4iUvUCMegUP89zR1Qxz7nZwXSvmIPyyDOxfuKAcuToHzO/DAiU7NJ13ClBj52Tabrj33AAxpaH5RxKqw1r2Ornz9JemlEY8rMQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oKDqJRh0; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oKDqJRh0"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fLg6r5kwPzlh1W5;
	Wed, 25 Feb 2026 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772037008; x=1774629009; bh=vJ804UQQ83e2Rnv1VzpHVArw
	1fg05t5j1rsobVSyUnM=; b=oKDqJRh0D6vrq2hrDuQAWCr7+ZHvJBmruObJB2yC
	0iJ5hP0MKKYub9DnzowIBVtpaYR/t1o/q2lsH/q+ZGip59k5WZlnRwcRJ3hibvzk
	XX1zZWi9SYyGvIhXtbI6y2DMxwCBZd7nE2u12PNF2f480MWUS/V3sUnc8j/kIImp
	ApjjQ5WxkD+DnWPSO6JWfzOa6/FVB48s1+C5FiIxzJlBcnnjWF7zR9ZYrEnlBk+M
	cAwRLs79KryJ2bd69dnH9kQoBbzxFZrTTxSVnwppuYjtyNVMQsiF+bcuY0xQw1be
	Tba3TOYq0lPendvfe3Rydfg39DaTa8uZl1TFSzqSCOMxhA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WG1e1sKu4RAY; Wed, 25 Feb 2026 16:30:08 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fLg6Y0fk6zlgr48;
	Wed, 25 Feb 2026 16:29:56 +0000 (UTC)
Message-ID: <4bc30e61-e83d-4368-98bd-78f7d22c3f2e@acm.org>
Date: Wed, 25 Feb 2026 08:29:56 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Daniel Wagner <dwagner@suse.de>, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
 Hannes Reinecke <hare@suse.de>, hch <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, "sagi@grimberg.me" <sagi@grimberg.me>,
 "tytso@mit.edu" <tytso@mit.edu>,
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 Christian Brauner <brauner@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
 "willy@infradead.org" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 "amir73il@gmail.com" <amir73il@gmail.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, Damien Le Moal <dlemoal@kernel.org>
References: <31a2a4c2-8c33-429a-a2b1-e1f3a0e90d72@nvidia.com>
 <459953fa-5330-4eb1-a1b4-7683b04e3d45@flourine.local>
 <aY77ogf5nATlJUg_@shinmob>
 <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com>
 <40edeeec-dbc3-4aef-ac86-691e1ed2ed06@acm.org>
 <CAJpMwygzTcBnKVp=bJWZpW9X5JdcP9Lj4H1BRBu2bNV_kGyDQQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAJpMwygzTcBnKVp=bJWZpW9X5JdcP9Lj4H1BRBu2bNV_kGyDQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/26 2:07 AM, Haris Iqbal wrote:
> Regarding data modification, if the tests do not involve any crash or
> reboot, then the VMs can be started in "snapshot" mode.
I'm not sure that proposal makes sense. If e.g. an NVMe device is
specified in the blktests config file, it probably is the intention of
the person who runs the test to test the NVMe driver and/or the NVMe
device. Using any method to create a "snapshot" of the device and to
run blktests against that snapshot changes the kernel driver and also
the physical device that are tested. Not modifying the kernel driver
or physical device that are tested implies using PCIe passthrough. And
the PCIe passthrough mechanism can only be used by one VM at a time as
far as I know.

Bart.
