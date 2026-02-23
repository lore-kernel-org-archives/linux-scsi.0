Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40043101DB;
	Mon, 23 Feb 2026 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771866522; cv=none; b=kbPCtO6v6jek+PrVJ9tMo9swSxYVJiGQC2B7JJyx+cDUBLD6x/1/dRgZeqeSnFyisWXBMSnaQ2p3dx1w6VYZRK9J4I9cZzK196tK+8bnH9SJQivKcgKDXEJfjufIb5iVmFtTBl5ggQSW0yDUY4yAOeqWQa7P62HRM+TyFij21T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771866522; c=relaxed/simple;
	bh=By1Ioj8GbL/V6zno4RRJtTxk1Y+neGd5c2WUwPqo6t4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qTs/6lMI0JuLPelFLz0y2rbABW8uwRRWMCbasGg8WcZKBG9HVY3MnZ/ljMequAjVgHSG7Cc1xniDWrn4PPegEZZl1BNYQnTgUPp1UckAe05NnfKvsmYn5YpSSW56K5vZDqKuJn82gLop4GRH+NsQC3Vl3sR/+BHzqr3Swxv1VLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=su8kXIo1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="su8kXIo1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKS414hq7zlh1Vk;
	Mon, 23 Feb 2026 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771866509; x=1774458510; bh=By1Ioj8GbL/V6zno4RRJtTxk
	1Y+neGd5c2WUwPqo6t4=; b=su8kXIo1EVVPqrEph4n4SLJz+IZllnLbmCMPcRRW
	zHxl9VLPCWWB7lAs/QFZXSzt+jpl1qYPIdQtgrYFZCmVKNY1WrNNdnmofyq7DeFD
	M6fimJiVVJTwBhkhCJFsK7BBvRT3IrPunQNfjIU4WPzXFFBMwKkFTNeN/anwE/jj
	Izb6OBxY00m75DfXIdnCTrok6Unii/ABlX+p9C/YSd23OHNYrUpHWZ0W9ECiMtmL
	F1FiXYAhzVPeM6vyUxVTp+MvD0NWSpYGSheNAQQ30qn5e8G0b81iOp/EEhHzTB8A
	F4eSZgZpMrTO5rvvjdSoFdq4mu1zqwUh/asrmDi6S3VzUw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Snina6HJ5Dga; Mon, 23 Feb 2026 17:08:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKS3q2HxZzlh1Vg;
	Mon, 23 Feb 2026 17:08:23 +0000 (UTC)
Message-ID: <40edeeec-dbc3-4aef-ac86-691e1ed2ed06@acm.org>
Date: Mon, 23 Feb 2026 09:08:22 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF TOPIC] : blktests: status,
 expansion plan for the storage stack test framework
To: Haris Iqbal <haris.iqbal@ionos.com>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Daniel Wagner <dwagner@suse.de>,
 Chaitanya Kulkarni <chaitanyak@nvidia.com>,
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAJpMwyis1iZB2dQMC4VC8stVhRhOg0mfauCWQd_Nv8Ojb+X-Yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/15/26 1:18 PM, Haris Iqbal wrote:
> A possible feature for blktest could be integration with something
> like virtme-ng.
> Running on VM can be versatile and fast. The run can be made parallel
> too, by spawning multiple VMs simultaneously.
Hmm ... this probably would break tests that measure performance and
also tests that modify data or reservations of a physical storage
device.

Bart.
