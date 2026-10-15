Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A9D2931D2
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032750; cv=none; b=tetgSbfJtHX1EnqPGHMcCt5U6bde2+hT3+VbJgDW8/Rk/8xR53o40FtrnweF7aFB8Sypn80ccqKxHCSBkddgyJ9gXtbKJQkWqqbRTiW74RZF13DepBATgM5Lv0s2QX3RFt7jHC7B1LgJ1yvUCkHulJ3SRvCJQCQdkiPOWU99+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032750; c=relaxed/simple;
	bh=gHUIKUIAzPHrPfCjVnWyAPWvm0kVa36MMM9Ye9UTV/A=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=AyseBBQAxdHJsuXbBwEDZtzQCmuk0Jxbx9fcQuMhZRRznIGJBIEuY0w3mP4RIsdcrcXHhKeBWkfiqHY5MinrSH8x4gQ8na4fwXRdm2X1OFSlDv44EnkAeIzmdc6FRrDhkSv+74CtFyMDFhlrhqlO3+lTs9QJQAUsM+LW5ni+obI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gw7LgFUj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gw7LgFUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B58C1F000C4;
	Thu, 15 Oct 2026 02:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792032748;
	bh=fM2kZTybnK7npC9Mf+ydqQNKPAUrIDcQlqQ6eb1u70A=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Gw7LgFUj4mdcoDQiDRbWUEI95RsFZ25WkkJWdI9RC2cFC4DIH5nHY1DeixkNm80Kd
	 h37PdMiy1KxovHXaX+KcVje6687lUBZQ/wquNNsyZGSBQ7R6aV/eaneQwZanam8rFP
	 rWzL9+FSRQAv56BtyTF27aN0N6ut93gm59dIvwJNnO3M+ajCpHeyUfUNgt5qKw+mdx
	 +L99fZVobGDIANkpS7xT9LOZM+7tOKj5L1ZB2LAGrv2mF7aMkNdfwdylzrCqmNQec5
	 DWl/rCKFFFUxf0P7Wce3o+8SM8IhAdQcHJqJQiHMkWngKSwsQY8GLT58IPDfPe6xSb
	 4mGSv4DLqH1Yg==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/54] scsi: Enable context analysis for most drivers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
Message-ID: <yq1cxtbekw7.fsf@mail.kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Date: Wed, 14 Oct 2026 22:52:26 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> This patch series enables lock context analysis for all SCSI drivers in the
> drivers/scsi/ directory except scsi_debug.

Applied to 7.4/scsi-staging with the exception of the BusLogic changes.
Thanks!

-- 
Martin K. Petersen
