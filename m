Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795605556;
	b=n9reUmYaQf2jG3L+WBmcR27JEavdvMO9W0LheKPkiFnXB5+I8Xiz0gZN/a4MyLR9g7IB
	 6SepyrcWaho5LAHfdS4MgZUS3fohfmY5MmmiDuNAHn5nDbtpTnX9GztZeLchJvElAtmKl
	 riHPsI3waY/8jDKO+xtvh2FM/rLZMJvF9J5coXPPhcgSz0fpxEzHu2TwEsXjTLiyh7uu/
	 2V1qPXYqUwBqhlkzvkMwVkwCElsYTvs5AG9+ous82lXXiQRlcOqQnRLbTEgzg0YIMsyOq
	 71BQWi45ts7O3J/eBt0DjnlO6I28/5GzLyHVTkZ89rlToofrIQRiEBFsqpPEvq8HEgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605556;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Received:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CMS-MailID:X-Msg-Generator:
	 Content-Type:X-Sendblock-Type:CMS-TYPE:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=aol/YqFRk4VDFuOdOrJ3/H+/AAewZsmUni4kor0IGao=;
	b=bu00V4goKkAhR3Ljw2JodYn08uqKkca0I+UAIwpMEhEySfovWu+dQOVFglZr0l5h2J+u
	 587mICjLUG0vRJKde7WH82X6wZ3qQ9j2Yvj+ELondE67Pa9f9iF3Ab/8OrQit8P//mNL1
	 cuVPsvfRMDkqvLx3yB86YgWduRt8Un00iWkJkSdxSibNUGHnJzxtO2X4epFaXRUDWdOrr
	 uU0uwXjFBRYhOE0mE7gEj9DBl4xQQlYI9tQM9/Mhd8DuewwKMMAvFZcD3ZEVUooFupR1E
	 jWiK26uAlemrR8Ugb/EKFuv9do0DMawO41sloJOWa4lV+oRcNLAqQDjl28CHYQ/e7JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=mi7xmyv8;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB97606A327
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:19:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB97606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=mi7xmyv8
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261125111907epoutp011f60fc33dd4f1087f4b8e9e617b5443a~rRbtofG_x1182611826epoutp01Y
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:19:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261125111907epoutp011f60fc33dd4f1087f4b8e9e617b5443a~rRbtofG_x1182611826epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795605547;
	bh=aol/YqFRk4VDFuOdOrJ3/H+/AAewZsmUni4kor0IGao=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mi7xmyv8qCtkuiWVFS1WmHypp1B+5LuE/Onl2ebD59v8iDInV6Id5ZoH609GzZGWI
	 F+lqmxW/EE3mo6VYy1LjHcms5nMt9q6M66ehdngemO/F3tsVCwt3rRkDoK1u2ePUd5
	 Ha+SV2YHemHMj+pNDH0NMrhl3JhgMspyl0E4rtR0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261125111906epcas5p3ad070fe44b9392c0c2bc262258b274bb~rRbsMuv6b2807028070epcas5p3Q;
	Wed, 25 Nov 2026 11:19:06 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jZHHs0qfmz6B9m7; Wed, 25 Nov
	2026 11:19:05 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261125105614epcas5p4386cb5bb9966904c9ac38382eb6c753c~rRHukvjxj2438724387epcas5p4f;
	Wed, 25 Nov 2026 10:56:14 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261125105612epsmtip1d13c7f175a618d2175756dfce5229682~rRHsoqeWQ1560715607epsmtip1c;
	Wed, 25 Nov 2026 10:56:12 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe <axboe@kernel.dk>, Kanchan
	Joshi <joshi.k@samsung.com>, "Martin K. Petersen" <mkp@kernel.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Alexander
	Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
	Nitesh Shetty <nj.shetty@samsung.com>, Pavel Begunkov
	<asml.silence@gmail.com>
Subject: [LSF/MM/BPF TOPIC] io_uring dmabuf storage I/O: next steps
Date: Wed, 25 Nov 2026 16:25:16 +0530
Message-Id: <20261125105516.2160670-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261125105614epcas5p4386cb5bb9966904c9ac38382eb6c753c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261125105614epcas5p4386cb5bb9966904c9ac38382eb6c753c
References: <CGME20261125105614epcas5p4386cb5bb9966904c9ac38382eb6c753c@epcas5p4.samsung.com>

Hi all,

Nitesh and I would like to propose a joint Storage and Filesystem
session to discuss the next steps for io_uring dmabuf storage I/O.

Pavel's raw block device support landed in 7.4[1]. We would like to
use the session to discuss the following:

1. Filesystem I/O: RFCs have been posted for XFS[2] and ext4[3], and we
   are working on a combined series[4]. Open topics include files
   spanning multiple devices and support for additional filesystems.
2. NVMe/RDMA: we posted an RFC[5] for direct I/O between accelerator
   memory and storage over NVMe/RDMA.
3. Vectored I/O: support readv/writev with dmabuf registered buffers.
4. Polled I/O: enable polling for workloads that need the lowest
   latency and overhead.
5. NVMe multipath support.

[1] https://lore.kernel.org/linux-block/cover.1791975048.git.asml.silence@gmail.com/
[2] https://lore.kernel.org/linux-block/20261016091919.971295-1-anuj1072538@gmail.com/
[3] https://lore.kernel.org/linux-block/20261113070621.273953-1-mengmeng.zhao@linux.dev/
[4] https://lore.kernel.org/linux-xfs/20261124084025.2101804-1-anuj20.g@samsung.com/
[5] https://lore.kernel.org/linux-nvme/20261118103327.1788667-1-anuj20.g@samsung.com/

Thanks,
Anuj
