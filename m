Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F0E38AC8A;
	Sat, 29 Aug 2026 01:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787967531; cv=none; b=DBPMXrjMVok3vAdUkrL83DPu09qZ/gDOZuemmRQE4tdXupUnxKWDMnxvyTtqA9w71eb6/POWvWhrEGpy24frXXg9T+7U9m9OTMhS7KatMDf088+m4CJknokuFuo+89hYfVOKhhMeT9WZL8CUrf5ttbhc/J4CaodVMRXS6gH7fRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787967531; c=relaxed/simple;
	bh=MISYo5EAnLfiGluatJrOlAwYmxuLL353M8p5BjN3jCg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=D++6HdNxyuRzufQsGSsvvJIXO+IQAUDeRFTtcDueLMLv687rZHqWQc7axhS5ahq9pI2eZDQzJCozWCjMQXSCcqUKeoOuJldgpPmYUb3j7a4ZgLkfXS4W7Gl3OnUSKe6GSDCcq2HuX1WD72dVX16zTImUoOD6iekB563Flarvv6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxrPC0Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxrPC0Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C68D1F000E9;
	Sat, 29 Aug 2026 01:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787967530;
	bh=Re5XvAwgWVCTWF6fMwZLKtrKt/jem97G2EA9JnlFwmI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=TxrPC0MoowBBxNbDPzizuShZJUAhUDes11AHvVeqrQE/L4mPweY+iHKvZG8vuxCwy
	 kjtJwIDr2nwIVLUa95JjXx+Qv9RcFqUppemb1ZuBveijzNpee0bEJS+8ZAEdD+hRAq
	 +H6H3+umOXAkpjC7+hvOE88Xv59UdygH3LGHWV4VjWYC3gOBetdz/SIenC1+cELb1u
	 asepSuFrHhN8Q4sDJ2M34JI9cEt2OGZA2Dsczi59+RE6JGuHFrQEZTq8/0RsFUb7Ee
	 Huz/9TFhFOcM9M5VV7sJgUriGsR7C8U2htuQXhvB6wOqKDnbE0gZUeRMN06ass5Jwv
	 3JqF8j7foEgWQ==
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>,  "Martin K. Petersen"
 <martin.petersen@oracle.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kernel test robot <lkp@intel.com>,
  Madhavan Srinivasan <maddy@linux.ibm.com>,  Michael Ellerman
 <mpe@ellerman.id.au>,  Nicholas Piggin <npiggin@gmail.com>,  Christophe
 Leroy <christophe.leroy@csgroup.eu>,  linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] scsi: ibmvfc: fix kernel-doc name for
 ibmvfc_scsi_relogin()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
	(Muhammad Falak R. Wani's message of "Thu, 27 Aug 2026 16:50:37
	+0530")
Message-ID: <yq1cxv1k8o3.fsf@mail.kernel.org>
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Date: Fri, 28 Aug 2026 21:38:49 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


> Commit e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as
> SCSI") renamed ibmvfc_relogin() to ibmvfc_scsi_relogin() but left the
> kernel-doc comment referring to the old name, so a W=1 build warns:

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
