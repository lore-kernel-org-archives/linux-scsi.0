Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794661391;
	b=sG3SatR2QLsoo/y4WuBl7LxTVFiAKlHMxa+0KjPpZ876h5udfN9dnkVhCFyoHefi36Rn
	 M0PX29333GZHq4zbwjw3UdLIr9GC3L4Iw9xRcHrEAEVSxFmi01AAz0hFk4XBJOILtPTEz
	 LzRMMPalZwQv0gNNQ1oTcORMhiLNUVvr0JbkEk6Eo9Aj9JfvwqjXXshRL/+VTY/cu5T/s
	 1QyImIDVsT5zO7GDm7Yl2rLuFx8urLoLu/uwNkghtmtqv/iX/Bw7Qz+z4N8GWVnhlJ+Fh
	 AXIJBxYO1U04XLtPWjAZcToc3hwP95n5UWAJE34SxKg/CvG/fFJULpDbNTFhOLj3PqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794661391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
	b=f9Xcl1jAvGsXbPK8O5+FOGvZpKp4y8CK4g6p7mDs5ZTMHi3EJFqkpSOkvWbzlOmUdA1W
	 xqVLtd2UcwyJapXfyL+g182UBkXTGA8qaBeI4W9s+9QSxvxU6VcoD+y05RdIynN+foS2O
	 Igz8n+AzD9D2CVWA827QNdg//0F2WZ+4K99BxOftLHY7jpKvEBcQ+q5L3evIsrODRnER0
	 fKNo9XghzBvUEBhRveBMMpRqhaNc5kRZkTeD7FDZJ/t67xnhl3mCtfwKfcyYKS7pGiIUZ
	 Yx/aREQK3dgP4Toor3IZO7klM7yZfm3QTkZ4TpSgaG4nOnUM2RTLeLyvYigiIBFhDJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="PQZY/irS";
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2B7606A329
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 13:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B2B7606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PQZY/irS
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b56bca14b8so304279a12.3
        for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 05:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794661389; x=1795266189; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
        b=PQZY/irSZQGMq90p9E0zHzjuspbIKM11818nZq1cqfRmqa09WkLersottMZTn9igVC
         Snwb96STrO2sgKupD+PcpJBPe8qzNe+Iax93qD7Yl5SavKHmq6BlLIhj6mWzVlVXS94+
         k9H1mV4QoQzHVy+ahpRMPwGaQy31E6byhrBMG+QBYjcWRhE9eXIL3Un5Ynvyu29a+byH
         fYTOXKWrX6vvx1VCDYwR/5ETp9F6RQhf6szsPhKxF3dihYutdgW72y0EhKkQXFqtuhQA
         JTGcd3M09eC0Ddm88tFSmQmS8lziSoG2pq0WexW4DOwX+2PSHw1NWUszZvtnOwBb40Bu
         C3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794661389; x=1795266189;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=voIO8VlTvL+eYASbCl/rFeZp/+p5C7oqqVud5Dtqaes=;
        b=UA5q7vbQpusLYFCxE53Xl6ycTOinvSMTU3xhfdwaudgCrbKvxU/HPWEdIglBrqx4nV
         Hmxewcjj8v3iJJ6PXfwOuLZR934s9EEoJBT1cIL31mZThWuw/6f1Td7QJ9wm9MV8cRdn
         y/2wZxbG+pjvmsk/KkuGZCJ2u01EXkquf6wSGHJyZyR6NBN0wZW4LgK2yYkKtqe6rawo
         EUKJRMD4ZJ9AaR8JYVai5yKzLEez9Pf/gBJQCgouHgTNA/NWsapaK2ck+COl6wAadTaX
         SDHXmwyvUkYvwxjT5wjpzO7VL6+J5q/qQSzzc8PA+t6QOTuWgfz2fuS+IQ/tZtSEm0Sa
         xk8w==
X-Forwarded-Encrypted: i=1; AL+hErFUi/vndYIpdJu9uJO1PhLNiyCS4SckZ1hojT5eFry9KtQ6SK+w5uiHh+QAJELDBzigWqACxhiQ5ZMm@vger.kernel.org
X-Gm-Message-State: APuU4Z+XM9EeQr/uLLeeEz1mEqPw9tqEc06+wGf7GLWPNk3FR+zyjMuR
	zkUoVO9RbPnKnFWrQ7FMShFXPBL05cXvZZAcWK0rbjL2IC8F/tCprFc=
X-Gm-Gg: AYBFou2Z0iIBhBTEEDg9wNmcJn6G3yb8RohtssC6J5M9JldC2JjqUleHocWduLBTSwv
	GB4CEZAdqYo7K34y/Gg+3wv5UJlJm/bwREeSLF8bNKhoLPVMSo0BpGdtTas73YdmSCGBAdLHNY8
	KK9ZQ8m4Bxp2Kdn0j9TR1/wJ9xGd4fi5FUS8AgvvoQvV6qRuo7wI3AyeTZL/t5xubJLp+XRVcix
	lWWyFOmiY9pQhx5syqDlvJaJhMAt4kOFHAPIIQHq5JX81Rtf8uRDRycBaJnKXkDPDLR8bFv2JXs
	eQw/ZJUbxXTfXB1DOcljNm0OosjHK1DaHA1j8j0pNmE7ExVZJHxQLzdDjB251eQBsY7kvQuzj5Y
	ER8340dIkF0FFxZNX1gNx+0YjY7qkccsCJET9VlJX6ta8o3ggoIo17YA6iVLVMWFWtjIyAzgM+l
	re2kGkpRrBHWz14HuS7FSP3DNfsxEqW3H3chPh6AFFq3iDhowmbTw0hHOKkg4lVNaVPVLY9qYfH
	vtha/8oTQbygR0APdvLqvgsMYKkqxmMe8De/XtPkEr+T/0eVl9WjulPGac5SDxsMTzskOXu5lby
	qUvW7wAgwHfb904Pol9FgPr1gM21A8AtuMOK4QjEyZ9HoNe55JqAwCDcjt0N8DOz/Q==
X-Received: by 2002:a05:6402:a152:b0:6b7:c8fb:53cc with SMTP id 4fb4d7f45d1cf-6b7c8fb58e4mr3242227a12.1.1794661388747;
        Sat, 14 Nov 2026 05:03:08 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d7150529dsm5866714f8f.51.2026.11.14.05.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 05:03:07 -0800 (PST)
Message-ID: <00e03246-95dc-46dd-a2f9-89ad88f177d1@gmail.com>
Date: Sat, 14 Nov 2026 14:03:06 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
To: John Garry <john.garry@linux.dev>, Laurence Oberman <loberman@redhat.com>
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 mkp@kernel.org, Benjamin Marzinski <bmarzins@redhat.com>,
 Martin Wilck <mwilck@suse.com>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
 <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <3332329d-b922-45a4-8333-e8353e983885@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/26 10:05 AM, John Garry wrote:

> On 11/9/26 20:19, Laurence Oberman wrote:
>> 3. Smaller points
>>
>> - numa with equal NUMA distance uses one path per LUN, so with two AO
>>    paths through two HBAs, half the optimized bandwidth is idle (sdl:2
>>    above under numa). That matches NVMe, but users coming from
>>    dm-multipath service-time will notice. Would round-robin or
>>    queue-depth be a better default for SCSI?
> 
> Maybe, but round-robin may not be always ideal considering only a bio mode of operation is supported and no merging like dm-mpath RQ mode.

iopolicy can easily be customized per array/device via udev rules.
Just like it's done for NVMe:
https://github.com/linux-nvme/nvme-cli/blob/master/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in

Additionally, "service-time" and "latency" I/O policies are currently under
development:
https://lore.kernel.org/linux-nvme/20261026111019.3724465-1-kanie@linux.alibaba.com/T/
https://lore.kernel.org/linux-nvme/20260815173502.1185929-1-nilay@linux.ibm.com/T/

>> - There is no userspace tool yet to show heads, paths and ALUA state
>>    (the equivalent of multipath -ll or nvme list-subsys). I used a
>>    small sysfs script for this testing. Ben, is native SCSI multipath
>>    support in multipath-tools planned?
> 
> Well, the whole point is that we don't need userspace tools. However, I appreciate that there is no general SCSI tooling which could help here. I know that Himanshu M did work on a SCSI version of 
> nvme-cli tool previously. Martin may know the status of that.

Agreed that userspace tools are not strictly needed for configuration, but
observability is key.
A standard utility to visualize the device topology, path health and ALUA
states at a glance, similar to what multipath-tools provides, would save a
lot of friction for sysadmins migrating away from dm-multipath.
Relying solely on ad-hoc scripts or manual sysfs parsing can become quite
tedious in production environments.
