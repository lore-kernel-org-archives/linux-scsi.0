Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA992AE76;
	Thu, 15 Oct 2026 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031121; cv=none; b=CiiIG3JP4Co5M6gf3cZIRXCqu7uXPDmDw3QXNKR3NrRrGIgVByO3Dl/poIS/9Q8pwB79/dfDkVxyXjb+Xb6GkRiMFLP7/GyyIFxGKUY8R8odqfBSeJ7ByK2ILN8G6O5hze82cguUCNrG7jPnxgjSuNSvAjG8IXAg+DRTiYbgEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031121; c=relaxed/simple;
	bh=CBIavTSyzmeegEtcJIlCK3rnwJ8cWNwnQCBvs0C9aMM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Y1dLPyFhSpQV+SzBuSj18booi707og8/pvX+HyGJAF0FVb/AuXCMPsMxkqUdJvESsM9tQ3WVLmgPZhxF42wkTv2yuQZ4ner/261XDjJn6DewY+c1vmchqQDSmk5c3Qiyx5Vezf49/rRj33AAN9ari/HRHzthu/xInGu+AdBnsXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OiWb6e2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiWb6e2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5F11F000C5;
	Thu, 15 Oct 2026 02:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792031119;
	bh=medRj1v5k5OPOkAyf9AmsD+3Kc7tjIc2CrImasd0dJA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=OiWb6e2fKnmgWNWGr0lIg7AYgXK5rhFOmd1QMy1FCEKrFhcvTlZq35897xrAZNTSY
	 33dqeJO/Y8vQeWmcyhV8AeTS23b6DzrQokNdhaEmZeUKMr1nwBOPcUYeaElz/8hZnp
	 EydWEtjZK4C4hOU8z+N+1/Ulk9mbWNMddSqWtuuefXhrVlimDQoRQjeBniKxskRGwy
	 DKudjVOXQKT6KwiOEIaB9wFLJ58VJ1g0BAr/u99yXvM4xehoL00nWI0FiWgfQ2bYxT
	 4isrgb0E7PeWARrA8r6cDhpQx/JAwkjcFzhwLCP5xqw4XHiOvun4v2s2EnrONufwiJ
	 INdU+KH0SBpcQ==
To: Xingui Yang <yangxingui@huawei.com>
Cc: <mkp@kernel.org>,  <jejb@linux.ibm.com>,  <john.garry@linux.dev>,
  <yanaijie@huawei.com>,  <linux-scsi@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <linuxarm@huawei.com>,
  <liuyonglong@huawei.com>,  <kangfenglong@huawei.com>
Subject: Re: [PATCH v3 0/4] scsi: hisi_sas: Some misc fixes
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
Message-ID: <yq1o6cvem4a.fsf@mail.kernel.org>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
Date: Wed, 14 Oct 2026 22:25:18 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Xingui,

> This series contains three independent fixes for the hisi_sas driver,
> plus a libsas fix found during review.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
