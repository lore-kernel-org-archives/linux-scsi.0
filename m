Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E9817993;
	Mon, 24 Aug 2026 01:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536173; cv=none; b=qh62r05zymqZ/AWtCHaPl2SCfHScIndGtzLe9iF2MRXc4q48MZ3dUaFxjE1VH1Chz9rANWl09xEpjAoqCRNQ8F6xqnoHMbE2Yhre/JBT/IAyN0Y3gbIkxBnLgRuJayIuVFESlvTKPHAplbxlnoTVpwF97h/gZUkUyhLMQWkwUhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536173; c=relaxed/simple;
	bh=JqE66oEKJ9xuKwmRpFdIkAcN6bGp15SoXq8Lm2StvgY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=IzzJrNtXz08FAGrSjBUjuiXmARNsjoNWEhb0exR5emcllKnTpep9mKX+fyi71PxcQ/GkeW/Xiz4XuQt3GelebzEHmtrjMr85fIebW+lJ435WMk5Z70fEdgYw/PPAja03a0ujxHEbxckstI25o3fUjfGl+U7mdGPxZE6GXpvoT04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PRl1DB11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PRl1DB11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4FB1F000E9;
	Mon, 24 Aug 2026 01:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787536172;
	bh=dvhYeGdrsmblIkn0D+8o/UCtq9PDNoFI7FncdjSIkaU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=PRl1DB11Razz7/UncVbUp1a+cFG0ykiJOq5k88ViFVhsmTQ2LxG/SByQd1R0uxVbL
	 9fJlEhc36kKEKOZhIp488firoIibFzcRlRYbxBxJb+w5P3EW6l2XfRN1UAMQiqyYGU
	 jRfKQHqbO8SStaZVYVJEYZpEaqZm9ikh3vwvMXqJP7TOS2QZvYPMk3wAjI3dtuq+kI
	 XmcUw091FkqbaQSPDMOBurbROUfC1V9ZYU2b1Y9Lqsh0BhyeScePnYiFWV5qvXc3YI
	 aOMylyTEXZsAZIHwUWGeH2q3/ITaBYG3F6kFjIsZSRNqnauqQ87eBr+F90kGdgXm2z
	 htPWCCBuutbdA==
To: Dan Carpenter <error27@gmail.com>
Cc: Justin Tee <justin.tee@broadcom.com>,  Paul Ely <paul.ely@broadcom.com>,
  "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,  "Martin
 K. Petersen" <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove unnnecessary NULL check
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <an1trOAUeQmYEus_@stanley.mountain> (Dan Carpenter's message of
	"Thu, 13 Aug 2026 10:09:32 +0300")
Message-ID: <yq1zeycnv8c.fsf@mail.kernel.org>
References: <an1trOAUeQmYEus_@stanley.mountain>
Date: Sun, 23 Aug 2026 21:49:31 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Dan,

> The "evt_dat" variale is non-NULL at this point so there is no need to
> check. Delete the check and pull the code in a tab.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
