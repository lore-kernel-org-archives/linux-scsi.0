Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A02FDC4B;
	Wed,  3 Dec 2025 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764772769; cv=none; b=BlTIbmAbY9wAF3W/aMjEkyg8FIK26Ajhy7829ielVYGTWydpT/5Tr6vN8jVMOUWMNr6Yve/ybcEVS+B+9K8CZOtugQfL1iKyyc2/9KlH4GSp0WwrvcKGZiQEIMwgDj+l4tzpafhF0lQsqGHujAAA4xLGJ1yZs5GiXlqkehPjVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764772769; c=relaxed/simple;
	bh=EaA8YmIM0y/oHUtU5iLuxPzah0WlgVI53V+bCtvX9s4=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=bMK1DJldx4eMMYJfWGrCVt8re3KA3VwMm0Rn7PKleDxVRCG+vrQ4GMfXSeqHU6e6n5Rcs64F9ECYsZvmKy423SfNt91uwdfxIRGQUraAzsuIRDnsoo8Wx2zZddyFRWjPYSMU0mrVTxJ6DR3j6filgsxbMsfSjOILTcr0loB3Rp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=apN7HMWb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ryPPSK4p; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="apN7HMWb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ryPPSK4p"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 8AF801D000F7;
	Wed,  3 Dec 2025 09:39:26 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Wed, 03 Dec 2025 09:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764772766;
	 x=1764859166; bh=wrXP1Ug4tocTfL2b3V6Wl5aglARU9Bcs/BuYtR9is+A=; b=
	apN7HMWbtqTbb+mv+gdmU8H+3ZCLOGt1funIQvEE9ag1mpcgwOWn5reKMrdL/+Kt
	/XvsAVQqg4Jhd6JwoQRR4kZI3Ijb2F81qyAozrrKXLscKAc7aqdYb0AHpZX2AySC
	FcABYruQhKedS/56LqpEhjdJ7Sif4VfHmNd7ukUH11xkKIzMr8/cTYjQPInKZsS7
	oOcIsMFdcTvl88WhjWqAj59sZKs0MQGOeH+Pf+PovJC5tvCzB/kuwhnoRKzubVzk
	Aa03zoDQ1KnOxG3fr/z7JMUo2VRrUOSEYDStTkj2WrGtFC5IoilTjyqIDH5Z+VzC
	itEarBPmoN/o6iwY99cBLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764772766; x=
	1764859166; bh=wrXP1Ug4tocTfL2b3V6Wl5aglARU9Bcs/BuYtR9is+A=; b=r
	yPPSK4pzYeKSextwfmYKJyyRll84N6AsAcG04LlKCpL1NgM/JwckshKxW5uY6kBV
	cO/wxV2vQ0/rVWQxplj4PolFAicQB24h5Yg5QIxnC6Ew9WUYFsguBITyNR29t4b5
	Pg1su+Fx0l+n9ewZiGBiHlvt4o4fGziWy+/iHjljiF97efzgjffVzlU+Bgz/ZLCm
	R9e99aJHzqFrGpc8hARD4kdRh2foRn0AYDKjc5q1pkPVARNC0tBWF0TVw7PiDnyd
	9Mp+NzM5b8nEPSaKi2wNvcHN+IRrvs1Ddf6xN8/ZhMYNVhRJPNu2pz2w88DY0khU
	GE1o8/xOHpX/C5EhS25Kg==
X-ME-Sender: <xms:nUswaQIaa4D4k4Gssy_rk2vsTtsEvniQve28OIgSIER5o04_HuOnIA>
    <xme:nUswaa-yXng5i3LrLiTYcoMVigRV4cnj3v9uZ4QPrgHux1LMpjqsViaI5Tm9o41hi
    kw6jnsoT9Xu6ZrE9uzpKUMviZgCUvwSnF8TSnLNbo1kFJA0WZUufEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    ephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopegsvhgrnhgrshhstghhvgesrggtmhdrohhrghdprhgtphhtthhopehlkh
    hpsehinhhtvghlrdgtohhmpdhrtghpthhtohepsggvrghnhhhuohesihhokhhpphdruggv
    pdhrtghpthhtohepjhgvjhgssehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheplh
    hlvhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepohgvqdhksghuihhl
    ugdqrghllheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopegsvggrnhhhuh
    hosehmihgtrhhonhdrtghomhdprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvghn
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopegtrghnrdhguhhosehoshhsrdhquhgrlh
    gtohhmmhdrtghomh
X-ME-Proxy: <xmx:nUswaUbI9g7jTmarzEx_vjmfnOdupSR5KOiRnwFsIntMr0Pz9PZVog>
    <xmx:nUswabypaqy2eu2gSpZeq-fhHej4WzN5kK69Q-Y5CNT-o1oYGuyKwA>
    <xmx:nUswaTa-9AFrOFocQlzL-13Q0Tz9k4KkKLxGgEtU6oNrcsejL4ZTpg>
    <xmx:nUswacyVFm02TWWRo6MCeJGaBJxuWFsN5Vg3R6tefHyii9pLidkHcA>
    <xmx:nkswaUC0CJGESfqmKHjNI9iEctM1wYVDpWQm7zCsvnYi0YDkTqVml85O>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C762DC40054; Wed,  3 Dec 2025 09:39:25 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALO74ngA5rV3
Date: Wed, 03 Dec 2025 15:39:04 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "kernel test robot" <lkp@intel.com>, "Bean Huo" <beanhuo@iokpp.de>,
 avri.altman@sandisk.com, "Bart Van Assche" <bvanassche@acm.org>,
 "Alim Akhtar" <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, can.guo@oss.qualcomm.com,
 "Bean Huo" <beanhuo@micron.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <98ac8e0b-6027-4f6d-b5cf-b9ad9c856ecf@app.fastmail.com>
In-Reply-To: <202512031316.SvDwnvhy-lkp@intel.com>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
 <202512031316.SvDwnvhy-lkp@intel.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Dec 3, 2025, at 07:15, kernel test robot wrote:
>
> All errors (new ones prefixed by >>):
>
>>> drivers/ufs/core/ufs-rpmb.c:135:5: error: redefinition of 'ufs_rpmb_probe'
>      135 | int ufs_rpmb_probe(struct ufs_hba *hba)
>          |     ^
>    drivers/ufs/core/ufshcd-priv.h:445:19: note: previous definition is here
>      445 | static inline int ufs_rpmb_probe(struct ufs_hba *hba)
>          |                   ^
>>> drivers/ufs/core/ufs-rpmb.c:234:6: error: redefinition of 'ufs_rpmb_remove'

The declaration and definitio are inconsistent: the former is inside of
an #ifdef block, the latter is not. I think either way works, but it
needs to be the same for both.

     Arnd
