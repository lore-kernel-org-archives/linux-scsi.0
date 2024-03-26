Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87E1134C6;
	Tue, 26 Mar 2024 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711452476; cv=none; b=Q3s3XKypEzm2Rd2/KPQwH7N8Z6XTNOxEM63XJBqSOnOy6ebSUEJhfCtwlJCsTaemxATaP3tdK6KUQLdm2t5o4Cs44M7PgLvaZIpcR7JAc5ZYXyNMHnM1Alii33jhfWPptVqeew8cr8vbHnj3Mhr2IkNMZRnW5SC0I/vfxjFxVQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711452476; c=relaxed/simple;
	bh=Z+gA/7K8rkQtx8gPbtUDGJPhJpzQ8LtAMxX5LxdoFJs=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=K4AqXOuEqthK02eWc/3yx99ibMFDfFOWfrkfoBOgudP92O1UiBLqVUe5fp+sXH3tMC/okSRpibazhVA6DlIfxeB3RloDxFNIgtijd0RD0lTMtKiWA38aye0GK8ZZc6ROcIC+gZR0ZLSykQBYOQl7KZx15XbiBRsQA/l/5/LvSmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Dl9t/6dW; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Dl9t/6dW"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240326112750epoutp046b0520ab9ef492fa89cff80c7a04eafe~ATPRKJXCu1153811538epoutp04N;
	Tue, 26 Mar 2024 11:27:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240326112750epoutp046b0520ab9ef492fa89cff80c7a04eafe~ATPRKJXCu1153811538epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1711452470;
	bh=KvqRDcYvbbDHmK38k5UbQtwFg8UI3HdEkDUZrQqFbTY=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=Dl9t/6dWmP+Hfa1ZWYNXvXnhE1bZPfLxmf/RXkRo6KXxKTJc3qfR0S300OyVnF4bu
	 461OXrGU6wQuwILKRNKHTJiL+RG1oKaUCExjYiylhalKTKgh8Ofv0wZaDd31hl4dgt
	 ebAnzCdEgIZJ66oqJMBqDCXnXmNyBvxxKP1TgMSo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240326112750epcas5p1826ee93e91e35a0a4de0ad20e85d9215~ATPQwBsK-2467324673epcas5p1Z;
	Tue, 26 Mar 2024 11:27:50 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4V3nbS39lpz4x9Px; Tue, 26 Mar
	2024 11:27:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A4.3F.19431.431B2066; Tue, 26 Mar 2024 20:27:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240326112747epcas5p1a1adffea0ebe925790c1ab569af217e2~ATPOQ-GjX2467324673epcas5p1V;
	Tue, 26 Mar 2024 11:27:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240326112747epsmtrp137ea723f944ebf29129353a4198e5028~ATPOPAAg43193531935epsmtrp1X;
	Tue, 26 Mar 2024 11:27:47 +0000 (GMT)
X-AuditID: b6c32a50-ccbff70000004be7-57-6602b1345f0b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.0B.08924.331B2066; Tue, 26 Mar 2024 20:27:47 +0900 (KST)
Received: from INBRO000447 (unknown [107.122.12.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240326112741epsmtip2c4bb25269fa2afbc4dc9993e625bfc5b~ATPI3Fkaj0172501725epsmtip2t;
	Tue, 26 Mar 2024 11:27:41 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Christoph Hellwig'" <hch@lst.de>, "'Jens Axboe'" <axboe@kernel.dk>,
	"'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: "'Damien Le Moal'" <dlemoal@kernel.org>, "'Niklas Cassel'"
	<cassel@kernel.org>, "'Takashi Sakamoto'" <o-takashi@sakamocchi.jp>,
	"'Sathya Prakash'" <sathya.prakash@broadcom.com>, "'Sreekanth Reddy'"
	<sreekanth.reddy@broadcom.com>, "'Suganath Prabu Subramani'"
	<suganath-prabu.subramani@broadcom.com>, "'Juergen E. Fischer'"
	<fischer@norbit.de>, "'Xiang Chen'" <chenxiang66@hisilicon.com>, "'HighPoint
 Linux	Team'" <linux@highpoint-tech.com>, "'Tyrel Datwyler'"
	<tyreld@linux.ibm.com>, "'Brian King'" <brking@us.ibm.com>, "'Lee Duncan'"
	<lduncan@suse.com>, "'Chris Leech'" <cleech@redhat.com>, "'Mike Christie'"
	<michael.christie@oracle.com>, "'John Garry'" <john.g.garry@oracle.com>,
	"'Jason Yan'" <yanaijie@huawei.com>, "'Kashyap Desai'"
	<kashyap.desai@broadcom.com>, "'Sumit Saxena'" <sumit.saxena@broadcom.com>,
	"'Shivasharan S'" <shivasharan.srikanteshwara@broadcom.com>, "'Chandrakanth
 patil'" <chandrakanth.patil@broadcom.com>, "'Jack Wang'"
	<jinpu.wang@cloud.ionos.com>, "'Nilesh Javali'" <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "'Greg Kroah-Hartman'"
	<gregkh@linuxfoundation.org>, "'Avri Altman'" <avri.altman@wdc.com>, "'Bart
 Van	Assche'" <bvanassche@acm.org>, "'Krzysztof Kozlowski'"
	<krzysztof.kozlowski@linaro.org>, "'Alan Stern'"
	<stern@rowland.harvard.edu>, <linux-block@vger.kernel.org>,
	<linux-ide@vger.kernel.org>, <linux1394-devel@lists.sourceforge.net>,
	<MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
	<open-iscsi@googlegroups.com>, <megaraidlinux.pdl@broadcom.com>,
	<mpi3mr-linuxdrv.pdl@broadcom.com>, <linux-samsung-soc@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
In-Reply-To: <20240324235448.2039074-9-hch@lst.de>
Subject: RE: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
 the init method
Date: Tue, 26 Mar 2024 16:57:40 +0530
Message-ID: <001901da7f70$a0a566f0$e1f034d0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGDLceVEO+0my05uzu8PPcEBakLsgIMB2SiA3ffmdqxzGY/EA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxjAd+69vS3E4l3BecayiU0cgwWhCuygMqeiu4u4YNTskUXWwOUh
	UJq2zM3MWB4iUJDWJUzKQyhPQcEagTKLkIoSElQ2hIIiRUUUKuAAicgqa7m48c/J7/vO78t3
	zndyeLhgnuvOi5UoGJlEHC8knYnG616ePv56LMrvbL8bGpvvJVHtg1wSFVSfBCjvxTyObqqr
	cfSoaJBA5r67AI1mlOFouHU7sqbUY2iq6TyGUsvqSXS+9gaGGirnAep+bQCo7dxtDmqxNnDR
	8zsmDLXc+xTdNDzC0Nk71zCkMhtIpKs8iaPp8gYCpVwc46CqjjcYummrw5HtTD8HZfUdQ0VW
	JYZ6bFkE0lTU4qjU/IyLLhXfI9B42maU//IJF6kXukk02vUDypjJxNHp4k4SnXt8EOmMmfgX
	3nTP3b201nKLpLNGdARt1HSS9MJINk4/LtJz6bT2CQ7dcyuJvlyTSdKDfUaSVuvaAN1adIFL
	qyuqMfpqyYx9GVCS9G+lf+Jh738fty2GEUcyMg9GEpEYGSuJDhbuPRC+Kzwg0E/kIwpCnwk9
	JOIEJlgYEhrmsyc23j5locdP4vgkeypMLJcLfT/fJktMUjAeMYlyRbCQkUbGS/2lG+XiBHmS
	JHqjhFFsEfn5bQqwiz/GxeQPzHGkDwU/X8/rB0pQQ2UBJx6k/GHKsIWbBZx5AsoIYFOOZjmY
	BnBx5hnpsATUHIAdNTFvK+Ys9wlWagGw4vU8YINnAOZpm4DDIikfaChLX6p2o07AstRBzCHh
	lIEPjcNVHMeGE7UJPl3MXpJcqcMwY9GAOZigNsCCtlTCwXwqCFosyYDld2Fn/shSHqfWwaaJ
	Qpw9kgecf1LJYZvthE2nhpadtXDsRjuXdQacoeUvguUQ+FR/fpld4XjHlWXHHY7lptuZZ2ca
	6v5xZ9MxcKKqHrC8HbbdLSQcCk55wfo/fNlOLjBnYQRjK/kwI13A2htg6mTvcqMPoEal4rBM
	Q5WhE1OD9doV99KuuJd2xfm1/zcrAUQNcGek8oRoJiJAKvKRMEf/e++IxITLYOkPeocZQO0l
	20YTwHjABCAPF7rx02bfiRLwI8W/HGNkieGypHhGbgIB9mlrcPc1EYn2TyxRhIv8g/z8AwMD
	/YM2B4qEa/nWk0WRAiparGDiGEbKyN7WYTwndyX21f3Ds7HTzkbniW5rQbJv20RX+yoVx3N6
	n8Xlkm236mr6XHZJ+QEsp5EPQ5QfN1wMNX24RefF+zp0h82rueWouGRUH7Vnqtnlb6CoNmYf
	+n3fgsnPUtmyf7jNdVXhl0OfXEzgiSYp/bUTvcFRkdneEe0jnK5rQ/tdlM91R4LEx1+Ob41f
	zVi/S5luje1yKk43ry5P9lSUapXNdd8g9dFTSadt+d+qGg9FG+JeLOau/8joGdF0sK5jx9DW
	gWOiUtT8Uh+0poz78MJ7T4z0rluv4jqmNWeO1C1un6m4nbx6cHbWrCrKfGUuTHHNItQqS9qD
	qOOT5krrujfZHifGr/y6s31KSMhjxCJvXCYX/wvwTrePDAUAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTdxTH+d17e1tY2G4Lg19hGUsX4mDKRN04GuIGe91tcSEbiZNHtJEL
	4nithfGIxKogUHmUmRipKyLljQ4LYW0GzI5HpcmkLjBeAxGEAmMIUwGRgaM0y/jn5HMe3+85
	fxwBKRrneQhiE5I5WYI0TkI7UT92SLx27dUR0btrTE4wu/o7DfWjRTRcqclGcGlxlQSTqoaE
	Cc0IBQP9fQisuVoS7t96F+bONhCwoK8l4Jy2gYba+i4CmqtWEdx9ZkBgvNrDg7a5Zj78ZWkn
	oG34TTAZJgi4bPmZgAsDBhrKq7JJeFTRTMHZG7M8qL69QYBp/QcS1r8b5IGyPwM0cwoCeteV
	FBRX1pNwbWCGDzdLhyn4M2svlCxN8UG1dpcG668RkPs4j4TCUjMNVx+EQnlrHvmeL9vb9xmr
	HrtDs8rJcoptLTbT7NpkPsk+0Oj4bFbnPI/tvZPCNtbl0exIfyvNqsqNiL2luc5nVZU1BNtS
	9ngzDClo9uK138gQcZhTYBQXF/stJ3vr4DGnEyVDy7ykcVFax6VBpEB1jBI5CjCzDy+P/UEp
	kZNAxLQgXH6xg7A3PPGATsW3swuu3ZjeYhFjRfi6Jc3GNLMLG7TnaZvYlTmDcH5TBc+WkEyf
	My5YN5N2RS3C/W1bCkdmD55+nk/b2IWJwE0T1q1tFOONrxjPUTZ2ZvbjsbEzyM5CbC6Z3KwL
	Nk398HndVplkvLB+/nvSftxreHWqimdjVyYY63PuUfYZdzzb1clXIRf1Nif1/07qbU7qbYoy
	RNUhMZckj4+Jl/sn+SdwqX5yabw8JSHG73hifCPa+kJfHwPS1y36tSNCgNoRFpASV+esJw7R
	IucoaXoGJ0s8KkuJ4+TtyFNASdyd3WcKokRMjDSZ+5rjkjjZf11C4OihIEKPN6UX+le7eb8Y
	9pNXIetfHEd9dfTTgJjkbzofPvJ7I/zlD80a7Sn3fzK7P1gKmp3Oi+w5Mh6BDoZWDI1IRhf2
	N075vLLzc8UhdU9s4Ig0VRgUslFpbFkpmPvyQE7aTUvi88M3DqdHl53csVPYndFQqm97unHA
	yJ+6cKokMDdrTdgu/sV82WF4j2jEss9BW70ket8QdHt+/N5T5cyG2+sJn4jvx+a+TXrql4J1
	CzORkV6pgx4rxYvdReKHx3yshd6zr+qEZMEXz56oq3wCxJ0r0X83n34huPRQuKv049FYS8Dp
	He+YX/rILbs3bHC3NjM6cyVn2XSkayUyIySCI8J9Gk9OFEko+Qmpvy8pk0v/BZqRtFD0AwAA
X-CMS-MailID: 20240326112747epcas5p1a1adffea0ebe925790c1ab569af217e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240324235542epcas5p166ee39673811a3fad942ab69b10b626d
References: <20240324235448.2039074-1-hch@lst.de>
	<CGME20240324235542epcas5p166ee39673811a3fad942ab69b10b626d@epcas5p1.samsung.com>
	<20240324235448.2039074-9-hch@lst.de>

Hi Christoph

> -----Original Message-----
> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, March 25, 2024 5:25 AM
> To: Jens Axboe <axboe@kernel.dk>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>; Niklas Cassel
> <cassel@kernel.org>; Takashi Sakamoto <o-takashi@sakamocchi.jp>; Sathya
> Prakash <sathya.prakash@broadcom.com>; Sreekanth Reddy
> <sreekanth.reddy@broadcom.com>; Suganath Prabu Subramani <suganath-
> prabu.subramani@broadcom.com>; Juergen E. Fischer <fischer@norbit.de>;
> Xiang Chen <chenxiang66@hisilicon.com>; HighPoint Linux Team
> <linux@highpoint-tech.com>; Tyrel Datwyler <tyreld@linux.ibm.com>; Brian
> King <brking@us.ibm.com>; Lee Duncan <lduncan@suse.com>; Chris Leech
> <cleech@redhat.com>; Mike Christie <michael.christie@oracle.com>; John
> Garry <john.g.garry@oracle.com>; Jason Yan <yanaijie@huawei.com>;
> Kashyap Desai <kashyap.desai@broadcom.com>; Sumit Saxena
> <sumit.saxena@broadcom.com>; Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com>; Chandrakanth patil
> <chandrakanth.patil@broadcom.com>; Jack Wang
> <jinpu.wang@cloud.ionos.com>; Nilesh Javali <njavali@marvell.com>; GR-
> QLogic-Storage-Upstream@marvell.com; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Alim Akhtar <alim.akhtar@samsung.com>;
> Avri Altman <avri.altman@wdc.com>; Bart Van Assche
> <bvanassche@acm.org>; Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org>; Alan Stern
> <stern@rowland.harvard.edu>; linux-block@vger.kernel.org; linux-
> ide@vger.kernel.org; linux1394-devel@lists.sourceforge.net; MPT-
> FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; open-
> iscsi@googlegroups.com; megaraidlinux.pdl@broadcom.com; mpi3mr-
> linuxdrv.pdl@broadcom.com; linux-samsung-soc@vger.kernel.org; linux-
> usb@vger.kernel.org; usb-storage@lists.one-eyed-alien.net
> Subject: [PATCH 08/23] ufs-exynos: move setting the the dma alignment to
> the init method
> 
> Use the SCSI host's dma_alignment field and set it in ->init and remove
the
> now unused config_scsi_dev method.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/ufs/core/ufshcd.c     | 3 ---
>  drivers/ufs/host/ufs-exynos.c | 8 ++------
>  include/ufs/ufshcd.h          | 1 -
>  3 files changed, 2 insertions(+), 10 deletions(-)
> 


