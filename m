Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBE431F99C
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 02:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791945692; cv=none; b=Ny3+15mtYAmqn50zH/GL/aK/IUp98Y4JWqum/M5EZhIfWQ8E8i7P1oMvwfGm3/754lGnlNPfXXDBMWs8jvCZ6TQPNwSgvnJfZFFYuaFNFAXaFThnWMd9awC4Y54mQZiuglSJZQKlBdwHr+N/84jg+KsBuhwLnng2OkatzSOuctA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791945692; c=relaxed/simple;
	bh=q2Krj1N5tdSO+V5jbFOikmjLdpaFJtY2U04nRk8UYJk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=RltIZZr22SvO2WTDntBXcOLA3+WBTCccB4ZXp6ZwYsdX+5x+UHuKyf1FjNb9/ndP28yYElPYwhvYCVWbZIUiXP3qgARsTfdrV0QY/LNsow4iFgN35+L7DEqDZsEps12w4bfbxPVhs7tMJtPOhenQFH0xm9QIEaIMhE5JLeC12hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oc+mHtuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oc+mHtuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B51F000FF;
	Wed, 14 Oct 2026 02:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791945691;
	bh=mT8odI1amgpwlu3m7fbrEPWbQaVoQpyipAzsTRwhm88=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=oc+mHtuP0ueXxx/L/roGjNZpxKfKP5HVZVsyVT3TtRiFl6l5muvdss4KG71kAd62m
	 1dCvA5WKJZ7nIjPTDYRVJ77Xebjx0qzwmmijF6LenalYkPuTEe6+vi1Iy7wDsv0acZ
	 J5q6hKxX7STj/B3maoXe5uH53UeuWHs6WEoR6eRzs0KT+QVtAThkV8QTPGAyQajayN
	 I0uC+z2jbScF06Jwu6EyDe5mpWb+tUvFNcrXOwdo1+DT+TnxiTUNRMVH7mok7CpdFi
	 eoKs6OoNaYgfM9Aly+ZK4XL0CoeLFWwxftwXKx6qQJ5YiNZfJzicnICupuMDk1pGHd
	 P2Sf9JG9967pQ==
To: Brian Bunker <brian@purestorage.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  "Martin K . Petersen"
 <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  James.Bottomley@HansenPartnership.com,  Hannes Reinecke <hare@suse.de>,
  Bart Van Assche <bvanassche@acm.org>,  krishna.kant@purestorage.com
Subject: Re: [PATCH v5 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261006184423.41204-1-brian@purestorage.com>
Message-ID: <yq1v775f1nn.fsf@mail.kernel.org>
References: <yq1o6gbdhf5.fsf@ca-mkp.ca.oracle.com>
	<20261006184423.41204-1-brian@purestorage.com>
Date: Tue, 13 Oct 2026 22:41:30 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi Brian!

> It looks like this series didn't make it from 7.3/scsi-staging into
> 7.3/scsi-queue, and it's not in 7.4/scsi-staging either.

Please address the issues reported by Sashiko and resubmit.

Thanks!

-- 
Martin K. Petersen
