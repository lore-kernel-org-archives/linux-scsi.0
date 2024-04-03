Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB043FE37;
	Wed,  3 Apr 2024 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712120715; cv=none; b=YrXZwX0qk5GYwC9ZTL8met826Kjqt2PMUJ0ldGync45SjOOLrJqEWZUgfooK2ufoGhS1WaZuBtwCJv6MyullKMduQElLAm7UEIVT5+h6Q309GpFucABIq2TJf/PhcSKTuPQEhuK0SQrlYf0LG+Kv58TmYxj5DCjZhz351wWEGDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712120715; c=relaxed/simple;
	bh=JcHYotXRRV1MqcPELi+vORTrZSc6KnEZ0kSwZKLhDvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=HyrpWcPw1gllRlELjNho/qsWgCstOvhnmkNfbEcgWpyNUMkRdiYR3PJS2+/xD7qY9Mghz7ibDArSJra/Sjh4VwotXJBx9hBe6uWFJDqGCXD8+28lDG0xtgxu+FoFhDJggki2+icoo6ejiarfXqS6U25vzIsFtY4VEqsGrYeFO6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bU4IHYY1; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bU4IHYY1"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240403050510epoutp02853d2b02a644c5237f17d3a2ff1f4a8d~CrLcTIlQQ0562305623epoutp02i;
	Wed,  3 Apr 2024 05:05:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240403050510epoutp02853d2b02a644c5237f17d3a2ff1f4a8d~CrLcTIlQQ0562305623epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1712120710;
	bh=HBVnHnFiaSeakBuX5QW6q4GFFtBNcnBXqAJmCexHKlg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=bU4IHYY1SfvZak/PDdnfH7ok7k5LVBhm5ve/uskvXLdHPYhWHFs23VYo44sLsPOX7
	 APcf4yNsgFgJ22PdaZYtBiPsOowmVz4Ae0sTFBjxrWkAqzR0WzflAT2KTQRxDL8YwG
	 0ZSKDS3NPVPgFY4OMxv+KIVfjx43yEGLp2UCJd6w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240403050509epcas5p403dd7ebe021271f903400e1c396af10f~CrLbNnpAk0822708227epcas5p4D;
	Wed,  3 Apr 2024 05:05:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4V8XkC68WJz4x9Px; Wed,  3 Apr
	2024 05:05:07 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BB.26.09666.383EC066; Wed,  3 Apr 2024 14:05:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240403050507epcas5p2af93e8855bc0d5d18f54c47f8d7252e5~CrLZCgT1j1997219972epcas5p2J;
	Wed,  3 Apr 2024 05:05:07 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240403050507epsmtrp1bd94e3a21b1b18ee4c74b0bde18aeb70~CrLZA8rX80314003140epsmtrp1e;
	Wed,  3 Apr 2024 05:05:07 +0000 (GMT)
X-AuditID: b6c32a49-cefff700000025c2-d0-660ce3831133
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5C.64.07541.283EC066; Wed,  3 Apr 2024 14:05:06 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240403050500epsmtip28e7bcd4a3801345fd12b86c84d7d1fb4~CrLTKkC3d1682616826epsmtip2C;
	Wed,  3 Apr 2024 05:05:00 +0000 (GMT)
Message-ID: <6ea60c2c-9dba-43e5-e91f-30c833146499@samsung.com>
Date: Wed, 3 Apr 2024 10:34:59 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 01/23] block: add a helper to cancel atomic queue limit
 updates
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "Martin K.
 Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>, Sathya Prakash
	<sathya.prakash@broadcom.com>, Sreekanth Reddy
	<sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani
	<suganath-prabu.subramani@broadcom.com>, "Juergen E. Fischer"
	<fischer@norbit.de>, Xiang Chen <chenxiang66@hisilicon.com>, HighPoint Linux
	Team <linux@highpoint-tech.com>, Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>, Chris Leech
	<cleech@redhat.com>, Mike Christie <michael.christie@oracle.com>, John Garry
	<john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche <bvanassche@acm.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>, Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240402130645.653507-2-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTZxTfd297W4gslwrhgz9m18yIKI9qqZ8bqJmP3YUlc0wnmpnawYUq
	ULo+Nuai6xQEKkopY2oZohQRRGQ4W8qE2SKPoPIQsDiG8iiQ8XASnS60YlZo3fzny++c73fO
	7zxy2DjHwQpi75cqablUnMIjvBmmmyuDQ4/alyRGGNqC0fBZE4Em5+4RqOpBHoGKKjIB+nF2
	Dket2gocjRYPMlC/rQ+giWwDjoZvbETTR2ow9LiuEkNHDTUEqqxqwZCxfA6gbocZIEtJJxM1
	ThtZaKarCUONA6tQq3kUQ6e7fsPQ8X4zgUrLM3H0pMzIQEeqJ5noYttLDLXOX8HRvO4+E2ls
	B1HxtBpDvfMaBsq/UIWjn88OMNBUxlp05tk4C2md3QSauPM5yn6ag6OTZ9sJVGLfgUobcvBN
	IVRvXwylH+ogKM1YKYNyjuXilL24lkVlND9iUr0dKurqpRyCGrQ1EJS21AKoG8WXWZT2QgVG
	XT/31PX8riaogvN3cWq0uRbfHrgnOUpCixNoOZeWxqcl7JcmRfNiPhVtFkUKI/ih/PVoHY8r
	FafS0bwtH20P3bY/xTVlHvcrcYrK5douVih44Rui5GkqJc2VpCmU0TxalpAiE8jCFOJUhUqa
	FCalle/yIyLWRLqI+5IlTuMAU9aFpec+1BFqoMM0wIsNSQE8f+8FrgHebA55HcDHBY+ZbuMJ
	gN/fvO4xngPY1z9IvAq59qwPuD8aAbT3X8TcxiMAbxdexhdYPuQG2GG+z9AANptBvgMbJzlu
	ty9sPzPGWMD+ZDyc01gWky4ld8Kn5dZFjJMBcGCsZLE+P1IFnWXji/lxsmEJ1A5YmQs5CXIl
	7C5QLXC8SD5s+aPOE7sM1j36abEfSLZ7w8KRGaa76i3QOTHqwUvhVNs1lhsHwcm8Yx4cD3vO
	dHoGo4T2BqsHb4SZt/LwBV3cpVvza7hb6014wjmGLbgh6QOzj3Hc7LfhQ924RykAjpwu82AK
	Dqu1hHtUVQA6psqBFnD1r41F/1r7+tfa0f+vfA4wLoFAWqZITaIVkTK+lP76v4XHp6VeBYtH
	GPKhGTwYng1rAhgbNAHIxnl+PnMxXokcnwTxNwdpeZpIrkqhFU0g0rWefDzIPz7NdcVSpYgv
	WB8hEAqFgvVrhXxegM90ZnECh0wSK+lkmpbR8ldxGNsrSI1pAify7NRFx1CsZJ9IovPNzx6U
	fzIUOuOYmYqlSixf/FDYk3X6vfCPvQzLIlcntlita1YX4rvqM3z/lM06dsuIF9wTgz2VK9q3
	bVq3XJKdbMwdatx7aGlccFN/T7Qt5yDSq805cfgvB6ynlEOJI3vB1i/rr7y1YnVu8bPd5/r8
	75huLSnSGe6ZDHu+tRw/+dfDklh2QMEH6WWCw3kipeNUzJrOhoKA3Oq2Xe/fshkzLSfDY5ov
	sNSzvbYDqeW3lz/f/E9LtZ/5kN/L4c2m2tz0KGtgYn3cG8KRPMN3gVneouoTdaptHfNh7fkr
	Xh7OsLdsLbq7M8tUm77q789SjIYdYbErh3gMhUTMD8HlCvG/O81uAg0FAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf1DTdRjH+3y/3303di6/TYkPZBFQdwoJLj3vqUur68TvhXdlWVcW5WJf
	kGKTNldokSiu2PRig8sbUxiMQOYUkHOw5JeSkHQQEHPYRCQYyI84EI5iEbsYqzv+ee71vJ/n
	/TzPH4+AFPfywgSpisOcUiFNi6SFVO2PkeGbs4fXJG8Z2ACDRbU0jHtv0WC7m0vD2QoNgjMz
	XhLa9BUkDBX2U9DnciIYzSklYbD5RZg8UUXAdJ2VgOzSKhqstlYC7OVeBN1/OxBcM//Cg8ZJ
	Ox/+6GohoNEdA22OIQKMXU0EnOpz0GAp15Aw+72dghOXxnlw/icfAW1LlSQs5d3mgc51FAon
	swjoXdJRYCizkVBd5KZg4uRWKJgf4YN+sZuG0Y73IWdOS8K3Re00mIf3gaVBS74UzfY6E1jT
	vU6a1XksFLvoOU2yw4WX+ezJG1M8trdTzdZc0NJsv6uBZvWWa4htLrzIZ/VlFQRbXzy3HH7L
	otn8kh6SHbpxmXw9dL/wBRmXlvoZp4zbeUB4cNHu5qV3ERmnB/LoLJRH6FCQADPb8JV5J/Kz
	mKlHuHhEFtBDcLZrgR/gddjqu88P9EwiPDrD87OI2Yk7HbcpHRIIKOYp3DguDsiP4PYCD+Xn
	YCYJj/9jWLGuY97Cc+XXaT+Ty+PdHvPKCesZNc71GZdZuKy3rcEXNVcofyJmbAi3aJsI/wKa
	2YS789V+QxAjwa136v4btB3r7DoU4HBcN3WO1COxadUdplX7TKssplWWYkRdQKFcukqeIk+S
	pEsU3OexKqlcpVakxCYdkteglb+L3uhAA2ZfbAsiBKgFYQEZuV7kTQhKFotk0iNHOeWhD5Xq
	NE7Vgh4TUJEhIonxrEzMpEgPc59wXDqn/L9KCILCsoioPa5a9YJnJDF0uzD0yBtV0w2Ljphb
	xqqFYPHWDb/GbLZbyrXvffrk/R3xd6xrH01+IsfRRF3a4SubEXzxe/MuLEmwfXfzce9DXOLd
	qLVhz+XP9rMZB0Ly9Ve3jQ1klX3ZuvHlV+czx3ZZRNZ7SxM9SJRc0PfX2N5jzzyt+0auHfjo
	+LMdgyXJmVMZH6tLO5wGrcI5Hj/VbHg3P+qH6qvBDwrfju3vemdT3O69lbh4Nrch++HnZ7rM
	vHpLtW/ig5/Dv1K8prku1yZmOv/cp6JFEfszwnebRdOZ3lc0JR2GiPjUzAdsz5tbEnTaCdmp
	iNbpmmPHe91x5zWVX1My+7kRd2j7TWMkpToolUSTSpX0X1F7cdTmAwAA
X-CMS-MailID: 20240403050507epcas5p2af93e8855bc0d5d18f54c47f8d7252e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240402130741epcas5p2b14c5c7f4ed5999a0b8816f9d007ca08
References: <20240402130645.653507-1-hch@lst.de>
	<CGME20240402130741epcas5p2b14c5c7f4ed5999a0b8816f9d007ca08@epcas5p2.samsung.com>
	<20240402130645.653507-2-hch@lst.de>

On 4/2/2024 6:36 PM, Christoph Hellwig wrote:
> Drivers might have to perform complex actions to determine queue limits,
> and those might fail.  Add a helper to cancel a queue limit update
> that can be called in those cases.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
