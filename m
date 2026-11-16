Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794796333;
	b=D0Hg8FvwXMUn10M5OVN1HNFox0pwZxbSQLz6ckikZZOANbAC004LfDLsjp+A1ln+qA9H
	 zJ0XggHBq3nBUDoe5tUzKQCpmEUS99VWnb8mPspry6yip5woQKinfyqmFJRBgHg4IneTe
	 k4/NUJEJteVaZ2Pbxp0kjm6iAp19xd06g5yd1FuyHR11K+oj5bME9vPd7b+qoNWX4Nb13
	 H4SzY0P2uWraJ86KlxisaRqVjqOaAHChCTfhW/3TrB9/f/4OyAE/q1nFQHfThS99q21kB
	 1LuTAJHFb1rKhf/VgHBpxH0yYI03QTh/Ohxt2oXUzR6wehkOgEUODqajUInwohRHn6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794796333;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=qP0oQ8pgHCHQzk/+nldvTTjF2Xe/AkvM0ngljoymRm4=;
	b=JUhQLgrzJmm5tlEwmT2dJEinZJaanLPbmwPIBF3NUFQPWVY8JvDSLl5pqBnh4r44mgdn
	 DOKtraLWojxLRRp3Y5oZscm4wdtQmK3EN+V9MTMsT/CjFguctFAAh2S7mcu+WenVc/msf
	 E5bxILfulMXxYI5SRxWHQKtEJ8oVX6y+mybyFtczh+xMbHJ3BpB70np1nNIJVdCVwkhPI
	 +LHsidUSFDFdJ6dBS7dFFfFIkpD0P2wTWF1Uy09rLDPRltscMlKyqSHOyLghiWIjPVBgp
	 YDpnnmPh/G3GrYlQf+u8s55Bwt8wnD0KGcy9SbTw7dLWdEcAzrrB4Y1Vqy2ksfdyv/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n097wLUh;
	arc=none smtp.remote-ip=209.85.161.54
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FDC606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 02:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12FDC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n097wLUh
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b19e291cc6so3795609eaf.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 18:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794796332; x=1795401132; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qP0oQ8pgHCHQzk/+nldvTTjF2Xe/AkvM0ngljoymRm4=;
        b=n097wLUhxoclfA5QObXODd/JJRRKdOMko7wT9CCDpExxu+EqWIRhSBNsYYJW1UNrAo
         oNR2SX6deWfZeNa0DslMa0sMX7UtmAo4zgIRgiABWk5pgtfUOw13ijcp3BLV3Cx6zeNf
         1bUrTC2qZRH5pmqtCBMte/Th5bR9t19SgALJVXzq6Vf7+4xIxuM67fweKuwVegbjyKw8
         emkTrBKSFEk8UIjCPafZo09qflxilxW1zvRkRkKTsOe9nWg8K/mFtD/SOTvEtC638G2M
         jBcu5xCP71GlWOtRLnusPyokNC5B0dn9ZA4K8Cg9ZrEg3zxWJMvW1nrpzEpjZ7RWAlVe
         n4Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794796332; x=1795401132;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qP0oQ8pgHCHQzk/+nldvTTjF2Xe/AkvM0ngljoymRm4=;
        b=eeVHJgwzmRKQWKrMWPfsh5Tjti315jQBcuTBKZp3+1p1MDJqZmdgVOqT6LXqWDYZsE
         f11di0TMCWEzvcYawLNytomjjyyIEx7FzoOEhOid/kTnUdmI8rJhWeU6SyQJvWFQAJsG
         hgVv2xf9xCDDku0vd+dgcbWWKIVipZsJxpFCa5fIukTSF20s+ZhxpqPe8ykNTbi76oG/
         yQs3IuTnc0tX98br+R9PLgbqPVXlmDYWIJodA6yJhjb5DpFMWDRmahIt8SxUhCOt0KXg
         rFUfUIqLqRLtDXyA0jq2ziakxf/VhTSVHonh66jiq/eiVlbLc8aoDiAmum4fQBojtYwt
         MWog==
X-Forwarded-Encrypted: i=1; AL+hErG4mu6fFKECunnfsBGodjF+aYVdpvgWKX3ItNGJiS7uOKfQy8eXUKiy0/RdWGF5uV3HWFKU3onxIyEG@vger.kernel.org
X-Gm-Message-State: APuU4Z/fsqrTy1GBxlO8XZ7PCtI8znE7rMMU3tJXh6N8bW+Gl28Sc4gV
	ibJVAEGs00U0tJWRnwCQmOd5VKUDDM5xeUspurpAoZeMZd9j247eTxJy
X-Gm-Gg: AYBFou1+EL3ZRxMp3NpshHTwpAtjLbNJgGbycNS4sM6eVo0Ee1MMg4tj0R3TE7yRk60
	+ERMYQ/F28qerFoE1GPe4FtZO7I6b6EwTV8sVaQLE44vSpbH/p9ikTpUUZc/ZOWB2cyoHn+2+wn
	pfUqDB7d13lyZ0kE+ZdR8neHwRnEdnqZcg5u2N19qpzFpwxMsxqLHXmqyJxo3LEgcGByMQWO5iw
	nHr7XDEaKO3F1DW/uc5Yii7xLuhEW5CchFMBVxykKl6eE9K0OkiLq1kiAhl0uOVoHFArTFXZmKV
	EL0AqbQ3uGRhKLJyGSTJk+LqggViT3F6pscRRMayeO5er48hlDQTPBnW30T8t50jo1Pg2MmUzoD
	DZxRs81OKtZtWM3UqdQZ3rOEaom/AVpJtk3V44mTcpK3Nz5wIV0AmoHTjso9ZCTBluX9/etMhPj
	asH82Zp+XxOhPYyt+LVb5e0OB8d9hZqfSCXwHRDlmTpH9otRH5g7QLIqTxfYAXdVs1DFhsgihJN
	/OsBE3VQV66OolsK/6J9EJlw5guMlY4ktzJ9baAu++VnATBrz8gecsDA+N7E0mcNNPzE3jL93QG
	24dF1vjDQFyPDWXXNu3NRCHXVuN9nsK+ZhYvhrQwhKgafuA8d+rywcerq6BfXW1syJ+2qwRXOl0
	svf7SQ6yx7jXNLImJuPWj1lqFr348ODFfFg==
X-Received: by 2002:a05:6820:1c83:b0:71a:ea6a:4f65 with SMTP id 006d021491bc7-71aea6a57c6mr2168123eaf.23.1794796331802;
        Sun, 15 Nov 2026 18:32:11 -0800 (PST)
Received: from fedora-laptop ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862c67db8basm1743225a34.13.2026.11.15.18.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 18:32:10 -0800 (PST)
Date: Sun, 15 Nov 2026 20:32:02 -0600
From: Ming Lei <tom.leiming@gmail.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH RFC 00/18] scsi: target: Add target_core_uring, an
 io_uring based user backstore
Message-ID: <avprIhtn1TuYLX1b@fedora-laptop>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>

On Sun, Nov 15, 2026 at 07:17:53PM -0500, Qiliang Yuan wrote:
> TCM/USER is how a userspace process serves a LIO device, for instance
> to export distributed storage over iSCSI or vhost-scsi. All commands of
> a device go through one command ring under one mutex, the data of each
> command is copied into and out of a shared data area, and the server
> has to parse every SCSI CDB itself.
> 
> This series adds target_core_uring, a second user backstore next to
> TCM/USER, built the way ublk is:
> 
> - The kernel emulates the SCSI commands. The server only sees reads,
>   writes, flushes, UNMAP and WRITE SAME as an operation, an offset and a
>   length.
> - A device has several queues. Each queue is served through io_uring
>   commands on its own ring, with no lock shared between queues.
> - Data is copied once, with pread()/pwrite() on the character device, or
>   not at all when the server registers the pages of a command as an
>   io_uring fixed buffer.

This is ublk's uapi re-implemented inside LIO: FETCH/COMMIT_AND_FETCH
per tag, pread()/pwrite() with (qid, tag) in the offset, and buffer
registration via io_buffer_register_bvec(). It starts without what
ublk added afterwards (queue affinity, recovery, auto buffer
registration, batching), and the sashiko reviews already found the
same abort and lifetime races ublk fixed years ago.

Follows two alternatives, especially with zero kernel change:

1) If LIO is required (vhost-scsi, FC, SRP, iSER), serve the device
with ublk and export it via target_core_iblock. Same per-queue
io_uring, same user copy and zero copy path, no new uapi. Please
benchmark that configuration, with UBLK_F_USER_COPY and with
UBLK_F_AUTO_BUF_REG, same 32 queues and threads.

2) If the goal is iSCSI for userspace storage, keep the kernel out of
the data path entirely. A write here still goes NIC -> iscsit -> LIO
-> uring_cmd -> pread() -> storage client, and a distributed storage
client needs the data in its own memory anyway, so the zero copy path
only helps file and block backends, which iblock and fileio already
cover.

A userspace iSCSI target on io_uring receives straight into the server's
buffer, with one copy fewer and no new kernel ABI. ioutgt

		https://github.com/io-target/ioutgt

is that design: one ring per queue thread for socket and backend I/O, lock-free
data path, NVMe/TCP and NVMe/RDMA today, iSCSI on the roadmap. It already beats
the kernel target by a wide margin: about 2x nvmet on 4k NVMe/TCP random read
and write, and 2x on 64k over both TCP and RDMA, on 100GbE. Adding iSCSI
there is a bounded userspace project.
  
> Patches 1-4 create the device, its queues and the character device.
> Patches 5-8 pass reads and writes to the server. Patches 9-11 handle a
> server that exits or hangs, and aborts. Patches 12-14 add flush, UNMAP
> and WRITE SAME, patch 15 adds fixed buffers. Patches 16-18 add a small
> server, a selftest and the documentation.
> 
> Not covered yet: protection information, and a way for existing
> tcmu-runner handlers to move over without changes, as they implement
> SCSI rather than block commands.
> 
> Exporting a 2 GiB device through tcm_loop to fio (io_uring, direct I/O,
> iodepth 32 for 4k and 8 for 1M, 6 seconds per job) on a 32 CPU VM, with
> TCM/USER and a single-threaded handler, then with this series, 32 queues
> and one server thread per queue. Both servers keep the data in memory.

32 threads against one, over tcm_loop with data in memory, measures
only the hand-off. Please run a real fabric and explain the -13%
single job result.



Thanks,
Ming
