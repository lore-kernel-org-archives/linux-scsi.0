Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350E41917D9;
	Wed,  7 Aug 2024 03:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723001983; cv=none; b=eX1QaRfxVwMPSNtEevHL3/zKtj9WRLuLCg8Yqc/BSaV1TFBGEar6BDC6nEn3t+68nAXTLzyToVKtrwNtn4JMeODLEfuXDPuOqQ01N3IEZoOZJBtv3yK5QbZPUZlA62KY+vBA0FOnoP+h7ie2pBOYRyYvlGho53IRVfdG2VYnvrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723001983; c=relaxed/simple;
	bh=1NxX7c+Lb7XXNquDdjuXVF38sWOSuvYblH0nBf18lXM=;
	h=Message-Id:From:Subject:Date:To:Cc; b=eb468PqBEXzcvE5AGIJ9QwEPdIxJJC0sbzu3bBaNPElkibtklYJPBZ2Rx9lIqCbWRDDY8AlUZCpelDMdfmeI3MfYS5h4vKhjZuM8lmeC5Ug162mTwK0137QAqPBDgJKffKw7vX+8GVHtmCUWuPfwHufFtRVfOWatGQEtiv2bJjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HmWfwpV9; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HmWfwpV9"
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 223891151AEB;
	Tue,  6 Aug 2024 23:39:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 06 Aug 2024 23:39:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
	:feedback-id:from:from:in-reply-to:message-id:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1723001979; x=1723088379; bh=KEDR2ogHBsfT3
	PrrVmvq6bSI0RjEiMuZh0Nx5OFgiPU=; b=HmWfwpV96JR3OzkAeLpeBGSdQ6Sq9
	gy/IwV3wVx6K2vBL/ohg97Oan1+yIUWGo+x0ekX8x/6TlZFb6RAS3WHX7mlmUMty
	rmSxQup0Ukoef2A38SJDeozBzHJe5O6fxGtZLB0DETOeCayXW/I1MY59Q15Nt7+e
	eQ0BUuthSWKsTg3/cOVRYF6QOylxPgiC5gR6eGnljz9R4oBuUVnYxJrMOn+ktNpD
	ENP7WqUIIvO8DAWQwi9jDi1CVcDBN978zJ9cKIALBsmb819O0Zv0WRarf8Nw7Xjs
	QxyhB5FoTAbYJbhDKsVOPGspGY3gf8OMilQACRysq9vP5HIaMecvR0s0A==
X-ME-Sender: <xms:euyyZq5G2GzgPuBN3SXi4CT50comvh5Vf-ebbwUkezI3_ktDXvqbww>
    <xme:euyyZj6I9PvLIWeNUWZ-CXUwziX418i7tOOWopUWv2-qLBVSZBLwPShe7uHioj4JD
    OW7VWldL0ezHkxAWTU>
X-ME-Received: <xmr:euyyZpcODk7ZqkCm_-i8iYqyX-HAjJAflsWUAOrAlim7TAEhsojitNW0sQpPmIb1iVfiKpUDfeTT3mts7lyqoQv-lUlzJZhPdyI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrkeelgdejiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkhffufffvveestddtredttddttdenucfhrhhomhephfhinhhnucfvhhgrihhn
    uceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrthhtvghrnh
    epheffudekteffudetvdffffehgedtteekkeefvefgieethfevvddtlefhuddutedtnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthhgrih
    hnsehlihhnuhigqdhmieekkhdrohhrghdpnhgspghrtghpthhtoheptd
X-ME-Proxy: <xmx:euyyZnJML4fHulYcq4ZeNN3K77mfS5QI6C7-lhhHzoJQ7H7ainOSCw>
    <xmx:euyyZuK8LZ-kY8dY0frEKxD5_yr-Jmfl1WnC0RlhXMdrXlimYsZfEA>
    <xmx:euyyZowUa3snNNpy-W4xvBDfzXjHNbj6Y06-_S2UjGF0r_H1ViMrJw>
    <xmx:euyyZiIZu4yNm-3F1_nnQQzQEY97s8o28PqdMpkH1sOcrI32tCCdjA>
    <xmx:e-yyZt_KyWE6nivn06JOoUN-sLJpNi98diMeSpuZHRgiYxBZ9ddk5GDg>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Aug 2024 23:39:35 -0400 (EDT)
Message-Id: <cover.1723001788.git.fthain@linux-m68k.org>
From: Finn Thain <fthain@linux-m68k.org>
Subject: [PATCH 00/11] NCR5380: Bug fixes and other improvements
Date: Wed, 07 Aug 2024 13:36:28 +1000
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
    "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>,
    linux-kernel@vger.kernel.org,
    linux-scsi@vger.kernel.org,
    Ondrej Zary <linux@zary.sk>,
    Michael Schmitz <schmitzmic@gmail.com>,
    stable@vger.kernel.org,
    Stan Johnson <userm57@yahoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

This series begins with some work on the mac_scsi driver to improve
compatibility with SCSI2SD v5 devices. Better error handling is needed
there because the PDMA hardware does not tolerate the write latency spikes
which SD cards can produce.

A bug is fixed in the 5380 core driver so that scatter/gather can be
enabled in mac_scsi.

Several patches at the end of this series improve robustness and correctness
in the core driver.

This series has been tested on a variety of mac_scsi hosts. A variety of
SCSI targets was also tested, including Quantum HDD, Fujitsu HDD, Iomega FDD,
Ricoh CD-RW, Matsushita CD-ROM, SCSI2SD and BlueSCSI.


Finn Thain (11):
  scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages
  scsi: mac_scsi: Refactor polling loop
  scsi: mac_scsi: Disallow bus errors during PDMA send
  scsi: NCR5380: Check for phase match during PDMA fixup
  scsi: mac_scsi: Enable scatter/gather by default
  scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
  scsi: NCR5380: Handle BSY signal loss during information transfer
    phases
  scsi: NCR5380: Drop redundant member from struct NCR5380_cmd
  scsi: NCR5380: Remove redundant result calculation from
    NCR5380_transfer_pio()
  scsi: NCR5380: Remove obsolete comment
  scsi: NCR5380: Clean up indentation

 drivers/scsi/NCR5380.c   | 233 +++++++++++++++++++--------------------
 drivers/scsi/NCR5380.h   |  20 ++--
 drivers/scsi/mac_scsi.c  | 170 ++++++++++++++--------------
 drivers/scsi/sun3_scsi.c |   2 +-
 4 files changed, 215 insertions(+), 210 deletions(-)

-- 
2.39.5

