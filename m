Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325B368964;
	Thu, 10 Sep 2026 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005317; cv=none; b=Bckp2O694R0wpswesp50kiG7hvdGlktqwm1WyFK5yP4DrphIGYtbuov/YAFonp+e1/QKz3DGM7N+7NblKLxkov1JlftLXMiYpDpD45v8aqkD6VwZ/Q0M/7TdyC3kOHyEfldeQJ5JdgKpRpUO4rmuvl1Z1RDlpgc8msAdYkJnskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005317; c=relaxed/simple;
	bh=KI9RgiSQyz4NAIYc6WRNosSFs0Cb1WPyMSdKmudAh4c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=rDXrZMlJ4Msqd7RPEVpgQzaPXQKfqsbaBvDbfxWK9JQlXyyIP7xvUUo9JO+JMPu/BDuAhyCWGYfYRxYV+zOaupvEZ23UhHHIQn/dj/aa7WIy+to/9pqVm6nrAgAeLDItPwWB8eq2DIwQgmNRmcRlnvPl8UG3qxskX8tqyOgbLko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EnSBio6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EnSBio6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943631F000FF;
	Thu, 10 Sep 2026 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789005311;
	bh=jH7jvytUi+mK1QimK0iBDM19vPOT7aCdsDa0cDy56z0=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=EnSBio6m20MPbCL01u0LzDonu4vR7RkDAX77/RG5IWpB3+Z3MnNwBGXx/WOYQQeSg
	 oCKeLURU2RzxvkEObRF5yN3OLSgMK13vnnChqD2v5L97aCcS4GHLgJZjTK+Dytaqx/
	 CH+OaIBtXUA/h3hS1PJ0uapz53a3F9k9Ho7oBX8xsQ4am4sVsVcznosCVgI569subP
	 23LYrr+LKRlQehDi/OR+iqtrrL9n+d9BqvFEg3L1xy0yeP538oecL4fchTr+VRpRxs
	 jLTzKIuuqi5L2nxMS+y7zs9O32A5D0zp14g3476UKfkiFo495MOpM8cxXoxPDni1tO
	 qgkRBIyBR+zTw==
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Cc: stanleyjhu@google.com,  beanhuo@micron.com,  beanhuo@iokpp.de,
  James.Bottomley@hansenpartnership.com,  martin.petersen@oracle.com,
  alim.akhtar@samsung.com,  avri.altman@wdc.com,  bvanassche@acm.org,
  can.guo@oss.qualcomm.com,  sumit.garg@oss.qualcomm.com,
  jenswi@kernel.org,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  op-tee@lists.trustedfirmware.org
Subject: Re: [PATCH v5 0/2] ufs: rpmb: make RPMB usable with OP-TEE key
 derivation
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com> (Jorge
	Ramirez-Ortiz's message of "Mon, 31 Aug 2026 17:47:59 +0200")
Message-ID: <yq1jyotc1la.fsf@mail.kernel.org>
References: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 21:55:10 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Jorge,

> This series makes UFS RPMB work out of the box with an OP-TEE that
> implements the standard eMMC RPMB key-derivation flow, without
> requiring any fundamental changes on the OP-TEE side.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
