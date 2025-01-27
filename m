Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33556B64A;
	Mon, 27 Jan 2025 22:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738017290; cv=none; b=ETKrjCVkZTky3794ZqWvcTeNmRSyrFXa+6pbkD9vEZlxyXXDGUAzRArXX5urJt/YcBY23B8GK1WqckzA4pp5XLGAGqoN5xizBp4yGB20yGl/CBdKXj1STRvVqXNru2kLspyB3QkiIY8cOH7/ScZlbbCWfmA6QoKGVln+stLK6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738017290; c=relaxed/simple;
	bh=NIdQaGJ0O7j2mAPWnOGxQEOLufGMr3jQ1Cjdlyo5+2c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=GiBwWvkcSEP/iS6DpVTbnatleXFvf5q+bCa2tXeDW2EHzaSepanikYnEf760RhNP0xFQW9Xv3tF6uYh4onNOo+AMfTiugxHTBLRe6tn21nfiUrN+wNfDdCSmfvmU6yR6sE45pWD8DITkvTYMJCBCTcQX2W3eLzgUvimqKrGcFPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4+CKRpVW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4+CKRpVW"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YhjsN2hRbzlgMVd;
	Mon, 27 Jan 2025 22:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type
	:content-language:subject:subject:from:from:user-agent
	:mime-version:date:date:message-id:received:received; s=mr01; t=
	1738017281; x=1740609282; bh=s/d/ASauSl/0SZWIhV1x7z0/BvXH1j1F4TT
	ySnAypFg=; b=4+CKRpVWIDp+Lu8ncj3j5j6vycAJpoDy98AGzuUWIEYBB8iyBxY
	/OmNznup9iclmYNKNzzsugyCJaSvu9sZ9YIVH+0Rvkipi1XQtVqUf+7etJ7UjAhY
	L4CXvzzGnf6x/0ghSXjrRmrz3iqPXAlsEgk8fqhMd8Nq5wbTPmcnisHyA9N0rq2w
	fb3gIKIoBB6E3aonkXqeAK2wpNgeC1Dk7SfOzkWlVCWhf4oroH2XACcUj+Mv1Dr/
	3gQPiI5xbxZbmvLFn2gUt/KtW2MJnd/dDq7VFDF4QszGsG1fXqLVEonUcqh4C8g6
	LDHAysFmCivHB6hnSvE67j/t/mmJ/eOgpmg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id opoqWIsJoUZd; Mon, 27 Jan 2025 22:34:41 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yhjs86sNDzlgTWM;
	Mon, 27 Jan 2025 22:34:36 +0000 (UTC)
Message-ID: <ad1018b6-7c0b-4d70-b845-c869287d3cf3@acm.org>
Date: Mon, 27 Jan 2025 14:34:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: [LSF/MM/BPF Topic] Energy-Efficient I/O
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Qais Yousef <qyousef@layalina.io>,
 Tero Kristo <tero.kristo@linux.intel.com>, Can Guo <quic_cang@quicinc.com>,
 Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Energy efficiency is very important for battery-powered devices like
smartphones. In battery-powered devices, CPU cores and peripherals
support multiple power states. A lower power state is entered if no work
is pending. Typically the more power that is saved, the more time it
takes to exit the power saving state.

Switching to a lower power state if no work is pending works well for
CPU-intensive tasks but is not optimal for latency-sensitive tasks like
block I/O with a low queue depth. If a CPU core transitions to a lower
power state after each I/O has been submitted and has to be woken up
every time an I/O completes, this can increase I/O latency
significantly. The cpu_latency_qos_update_request(..., max_latency)
function can be used to specify a maximum wakeup latency and hence can
be used to prevent a transition to a lower power state before an I/O
completes. However, cpu_latency_qos_update_request() is too expensive to
be called from the I/O submission path for every request.

In the UFS driver the cpu_latency_qos_update_request() is called from
the devfreq_dev_profile::target() callback. That callback checks the
hba->clk_scaling.active_reqs variable, a variable that tracks the number
of outstanding commands. Updates of that variable are protected by a
spinlock and hence are a contention point. Having to maintain this or a
similar infrastructure in every block driver is not ideal.

A possible solution is to tie QoS updates to the runtime-power
management (RPM) mechanism. The block layer interacts as follows with
the RPM mechanism:
* pm_runtime_mark_last_busy(dev) is called by the block layer upon
   request completion. This call updates dev->power.last_busy. The RPM
   mechanism uses this information to decide when to check whether a
   block device can be suspended.
* pm_request_resume() is called by the block layer if a block device has
   been runtime suspended and needs to be resumed.
* If the RPM timer expires, the block driver .runtime_suspend() callback
   is invoked. The .runtime_suspend() callback is expected to call
   blk_pre_runtime_suspend() and blk_post_runtime_suspend().
   blk_pre_runtime_suspend() checks whether q->q_usage_counter is zero.

It is not my goal to replace the iowait boost mechanism. This mechanism
boosts the CPU frequency when a task that is in the iowait state wakes
up after the I/O operation completes.

The purpose of this session is to discuss the following:
* A solution that exists in the block layer instead of in block drivers.
* A solution that does not cause contention between block layer hardware
   queues.
* A solution that does not measurable increase the number of CPU cycles
   per I/O.
* A solution that does not require users to provide I/O latency
   estimates.

See also:
* https://www.kernel.org/doc/Documentation/power/pm_qos_interface.txt
* Tero Kristo, [PATCHv2 0/2] blk-mq: add CPU latency limit control,
   2024-10-18 
(https://lore.kernel.org/linux-block/20241018075416.436916-1-tero.kristo@linux.intel.com/).
* The cpu_latency_constraints definition in kernel/power/qos.c.

Thanks,

Bart.
