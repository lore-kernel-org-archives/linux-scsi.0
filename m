Received: from wflow4-smtp.messagingengine.com (wflow4-smtp.messagingengine.com [64.147.123.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A997BAF9;
	Tue, 26 Mar 2024 09:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711445467; cv=none; b=mcKGBiqr674ThQg6XEpwitnd/n6d/11hQJuvNchNxc7eeDu1Cg5I7sAT3ISaWFSFu3eWgXQV9zuA1pcdXnfmaTEEayM+KM2Oy4wdWaAy7ggLYYDYgR0IvPz7N5ANkJHb6TX+mxNVj0L4jkuqLol+HnqDlUzeq8E3a0cKWyTLOco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711445467; c=relaxed/simple;
	bh=A385P8sstLom6kzL26rxDc9NxJPEN2ya79T0qMm//ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qe7RimVjhdg+JNchzlWhlpF7SIYo2P6BZlWPcqTVKtAMfHubotiq9uYtRaOh6ynwNp6IXqmwo7kVu9cfN5TKFgW/910YFjHIfo7JUWpezq5eBqNZ545sacYwkiOG6N5MnyxF423c3C8CV3P81f1mDJp00Rqg9k7U0Pv+p1FaQQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sakamocchi.jp; spf=pass smtp.mailfrom=sakamocchi.jp; dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b=IYcHZRbd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=bY6T7bCu; arc=none smtp.client-ip=64.147.123.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sakamocchi.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sakamocchi.jp header.i=@sakamocchi.jp header.b="IYcHZRbd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bY6T7bCu"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailflow.west.internal (Postfix) with ESMTP id 671F62CC0247;
	Tue, 26 Mar 2024 05:31:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 26 Mar 2024 05:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1711445459; x=
	1711452659; bh=JsIYIdm4lfmTSisZZ/DXBUcj1A+T+HA65a7uJi4J4Ag=; b=I
	YcHZRbd9sIqHicWGnTcnbloJibtoDxCJb1PAsLm0emFQ00jzFYEifmMbCFh0Otvs
	lXluwz6G8n8zwkeLXhb3kBgLnFeAKfJX1uqRW8zLv+64GlO3xbTSLa4NUfMhFCEt
	7+3d/oa1d7PJWNhAaDEEn9melllT1zZws8077/2fa0eQJmg/hxmy/IzDVwHUsp/J
	d39UqieNanc/fas+7PD/0DV2Dgb/85rvu6xKHD6yVWJLc5RsAlYZD7Egob+G2WMj
	+YqvJiwsckXS6iMXrm0lUUYcWNYyas1SYaXb1zqwr3EJTwYLwy4S7u9rEpSF8CKZ
	EWKSoaLtKvg+q2UZbRm0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1711445459; x=1711452659; bh=JsIYIdm4lfmTSisZZ/DXBUcj1A+T
	+HA65a7uJi4J4Ag=; b=bY6T7bCua+MtWTPA5KWjwHZJGaJziE/2KYz7fxj20W0q
	If1MAampCvCny6OBHZOHF32y3Kn4INASY9MYgcWPloU9RzC5JhZgXACJJCOzzbiW
	/omAae/qPOKlgipcJZ82q+o6szSvs3ct/aQhVAudZmjU8z6xqk/m8oufiOmPDVJ6
	YF6CvwTEorC8Wxd1l59IAGGH3W82NS2cMdOpqLw+Ta3jj1GIdknH5Dv3ilEqdHKT
	mKqhrk5Uuf2VkxqIu59mUzNvkU0PDH5U9YWz5zMlAvj+cKm+2OuZalJ5/GkFiGuD
	sNpVjilapH+Lgsu11iLndOldjMUmnQckKHNPtrBN8Q==
X-ME-Sender: <xms:0pUCZuTCEK_UZ1FIa04HDNbw09J1SP-yLjTPmiKJ7fcM9-9PLm5N5Q>
    <xme:0pUCZjzvYUNp_6AUn1GhXmXL5M4uvpS0meVqI5xxToMHvEoigMtmYJ7j1_wA3I0Sp
    HvgeEyM6lGYvNXn320>
X-ME-Received: <xmr:0pUCZr0cUziTQhpAkvv_eqG_J-dYqPzZf0V1SUH3f-nNStBcAUp6EA4jUGzRJEBOwGQMJiJimKe5XTYumtIHgMhG_YMg7hmSTdk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledruddufedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepvfgrkhgr
    shhhihcuufgrkhgrmhhothhouceoohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhird
    hjpheqnecuggftrfgrthhtvghrnhephefhhfettefgkedvieeuffevveeufedtlefhjeei
    ieetvdelfedtgfefuedukeeunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjph
X-ME-Proxy: <xmx:0pUCZqB2VFAGd4lCaBCxrik37ACK9ghaOvrLJuoQkMNILffyy2RCbg>
    <xmx:0pUCZngGTm6NYZ66zzHGXj6ZOAhF1W15NGgU_1lQ7VVTb5-DzgKjDw>
    <xmx:0pUCZmotj5j7QD4RQRHOqylb2bqFpvVFfCyUaWvVyWMamP166ANVEA>
    <xmx:0pUCZqgjGdSeR-bNNxKjy_SJixp8QgiXMk2VyLNValuMMfRrKA7OQA>
    <xmx:05UCZshvx_JveHrwhZignnPkPsX9dTUPRS4MjCrtEER4_LSUV7Gv69QHUMm5xSVi>
Feedback-ID: ie8e14432:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Mar 2024 05:30:48 -0400 (EDT)
Date: Tue, 26 Mar 2024 18:30:45 +0900
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,	Niklas Cassel <cassel@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,	Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>,	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 13/23] sbp2: switch to using ->device_configure
Message-ID: <20240326093045.GA139274@workstation.local>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,	Niklas Cassel <cassel@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,	Brian King <brking@us.ibm.com>,
 Lee Duncan <lduncan@suse.com>,	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>, linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20240324235448.2039074-1-hch@lst.de>
 <20240324235448.2039074-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240324235448.2039074-14-hch@lst.de>

Hi,

On Mon, Mar 25, 2024 at 07:54:38AM +0800, Christoph Hellwig wrote:
> Switch to the ->device_configure method instead of ->slave_configure
> and update the block limits on the passed in queue_limits instead
> of using the per-limit accessors.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/firewire/sbp2.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

I'm not good at any kind of storage protocol, thus execute me not to
review it. My concern is which subsystem provides the change to mainline.
I don't mind it is your subsystem.


Thanks

Takashi Sakamoto
