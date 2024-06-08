Received: from fout3-smtp.messagingengine.com (fout3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7C91CFB5;
	Sat,  8 Jun 2024 23:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717890211; cv=none; b=Wdkh65jLg6bNe/5npZGOpnsCDnngytwcRDkEgWlvEN+V9/P+K3dEWzmydCMoXiGWRxo9IP7mTnYB4DFPMjtkNvkPOLSSPEnkhTqhN+aHaTpMm/y+hAUycY7R++UJpLq9ENtRgG/+0XFZfutYPhGGjvm+Fhy3+zF5pd+oEols1aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717890211; c=relaxed/simple;
	bh=G3oxbVba7chF2PLo/s78i9Xh18ucT7MrDr6l7GlXT5o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=S/Dsk21p7ZkzFL0GXsNeQOe4Z6+SsXWaKQazuSjVnnbG24NwnmE29K+YKpJGTKgWMA+v01xShzCIKq+LJY22jITeUtSbqKcBKkHHEtEMlPqFLBQok/gW8loqEuL9xmqbhLZx6KRF53kjfIgAqNY8CHClMgMcR+K6fzG1JCKL0m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=none smtp.mailfrom=linux-m68k.org; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=YFiBWifZ; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="YFiBWifZ"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfout.nyi.internal (Postfix) with ESMTP id 3782C138009D;
	Sat,  8 Jun 2024 19:43:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 08 Jun 2024 19:43:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1717890207; x=1717976607; bh=rFl7yZds5ak8Ogf5iToJLM1N0ynv
	YeNb8QKF4g0xTIk=; b=YFiBWifZl85s+4QzuNKRLjtvVIoEk1v57RKPvT7nkYpb
	2vrFKcg67JmZ/6Q6tZWnYtFzR5VnmMfwedGaBMePFHAn8n+SpP2mWEitz86TaDmF
	3pXLv9AUmj2AA6iXncfwZBvnLLGbDIArotaaIfY+18dvZD+pY6jvdNuyOfLGpF/P
	0G0M9loyPC+W4+Gqx7HO1l/4nBRVpsPI5m9clYHFd5zfcOl7w0f7lDf0pLKW2Pqi
	+xjJBRgAkVEzXb9CXUswWQi7cQhm/vOiKPvKU1elEalKsIChWKvW4eWdBsRbEeD8
	5KM7GWAs82K2gJR3Xbxppo7X3bKrAKtPM8TRK0OCiA==
X-ME-Sender: <xms:nuxkZi9XoUEG4BarrC6hf95IG7-tQ2ecmDDi14OQaz4-PvMkanjCsQ>
    <xme:nuxkZit1UE-P--xUSV7sXHaqXf_ttP_d105fHsH-qFlDShpLPJPUGuldv33cl7TTX
    Dg9KDZNUHQvt3nIzNM>
X-ME-Received: <xmr:nuxkZoDdilNcJkQsLef_zRBBkyw75Wq9Uh_U32PRgPLWI9928H6c5chF9F0vEpEhQww7F01QeAHR6si2sOYVuisYJ_6IU7JjCrU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfedthedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:nuxkZqe7BMw3KAf9zfa6miBV7cxWdlpxU_aHEGhhqMu4nOedpEgM3A>
    <xmx:nuxkZnO00yrGnoGEihARFKbmVfYS6OSDulvNXqPUf3g6P4ScIdu35A>
    <xmx:nuxkZknDLQW5pGeONEzQSiej_pwbSgjBT_NAEZB7XQdU8EEhjcw3ig>
    <xmx:nuxkZptN2Rk9YTEcIALf28vIEaE0i5M0ctDUWxAeay825hMoz_FrbQ>
    <xmx:n-xkZuljFhn1OQaF7xVngPR0g_wzmPO2PGo5UAGzhaU6ugTretQr8wgJ>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 8 Jun 2024 19:43:24 -0400 (EDT)
Date: Sun, 9 Jun 2024 09:43:36 +1000 (AEST)
From: Finn Thain <fthain@linux-m68k.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
cc: Khalid Aziz <khalid@gonehiking.org>, 
    "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
    "Martin K. Petersen" <martin.petersen@oracle.com>, 
    Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>, 
    Michael Schmitz <schmitzmic@gmail.com>, 
    James Smart <james.smart@broadcom.com>, 
    Ram Vegesna <ram.vegesna@broadcom.com>, 
    Artur Paszkiewicz <artur.paszkiewicz@intel.com>, 
    "Juergen E. Fischer" <fischer@norbit.de>, linux-scsi@vger.kernel.org, 
    linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, 
    kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] scsi: add missing MODULE_DESCRIPTION() macros
In-Reply-To: <20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com>
Message-ID: <b013cb8c-0739-6c04-c479-7021dcb612cc@linux-m68k.org>
References: <20240608-md-drivers-scsi-v2-1-d00d652e5d34@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Sat, 8 Jun 2024, Jeff Johnson wrote:

> On x86, make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/scsi_common.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/advansys.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/BusLogic.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/aha1740.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/isci/isci.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/elx/efct.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/atp870u.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/ppa.o
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/scsi/imm.o
> 
> Add all missing invocations of the MODULE_DESCRIPTION() macro.
> 
> This updates all files which have a MODULE_LICENSE() but which do not
> have a MODULE_DESCRIPTION(), even ones which did not produce the x86
> allmodconfig warnings.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Acked-by: Finn Thain <fthain@linux-m68k.org>

Thanks.
