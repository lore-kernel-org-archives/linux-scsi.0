Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643A819C54D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908789; cv=none; b=lrmWBa89X/xJ1yYdNoql+3yrAvgJ65EUSVgSRXUruiO0qGkSzlhgbtGDejp7yL09hP61nUT0vSY8rWKh8YE2uEbn4Bs3yffv+EYDB9o2dl4rjZGTiKGEOJRxuX4d9Oh88v01x4qhC/4I6cXtrn/ibibL3DotQ1cDQxCV66Kiylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908789; c=relaxed/simple;
	bh=7kEhoFgKXeYsEKpGYb0XIJB6dbA4a1PAo7aBTRNGjNM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vELf5CzHhC4JD3TXfZCbDYYW2FWvDNi5lBhbWZ1zDOg9efZST93RGJVG0A3Yz1DVMF24k1zU+PSmtv0W70483fkBNARoIv/9R3DKzJoVRTENrdJL5J6EaZv9tKJK0mL79U22vbj0gtoUzAM3FEw9b0C1cJL0sF1R+a0+UCEVFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=nEC5epU5; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=nEC5epU5; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nEC5epU5";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="nEC5epU5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1727908786;
	bh=7kEhoFgKXeYsEKpGYb0XIJB6dbA4a1PAo7aBTRNGjNM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=nEC5epU5wbNGtaivmTe0EUd2ktodp3BFwl36215saRj8YWNUTeqgHRc+fDhAGCytY
	 iSzlImNPSBR0lhW+edb+drba9SsymVHJubUEILU/xsCeumZHPaNrph0Ip6vZKAmlOk
	 DbuuAuBcKO1Na6ObsdoPnL/OHloICBs90o1H3siI=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7F9FF1287199;
	Wed, 02 Oct 2024 18:39:46 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id MkXpJHif6lo7; Wed,  2 Oct 2024 18:39:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1727908786;
	bh=7kEhoFgKXeYsEKpGYb0XIJB6dbA4a1PAo7aBTRNGjNM=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=nEC5epU5wbNGtaivmTe0EUd2ktodp3BFwl36215saRj8YWNUTeqgHRc+fDhAGCytY
	 iSzlImNPSBR0lhW+edb+drba9SsymVHJubUEILU/xsCeumZHPaNrph0Ip6vZKAmlOk
	 DbuuAuBcKO1Na6ObsdoPnL/OHloICBs90o1H3siI=
Received: from [10.106.168.49] (unknown [167.220.104.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 20138128716E;
	Wed, 02 Oct 2024 18:39:46 -0400 (EDT)
Message-ID: <a81e712d44ddfcdb87897d3b988632df11797801.camel@HansenPartnership.com>
Subject: Re: [PATCH v2 01/11] scsi: arcmsr: Remove the changelog
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Date: Wed, 02 Oct 2024 15:39:44 -0700
In-Reply-To: <20241002203528.4104996-2-bvanassche@acm.org>
References: <20241002203528.4104996-1-bvanassche@acm.org>
	 <20241002203528.4104996-2-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2024-10-02 at 13:33 -0700, Bart Van Assche wrote:
> Since we typically do not maintain changelogs as text files in the
> kernel, and since the arcmsr changelog has not been updated since
> 2008, remove it.

This is legally problematic.  Under the terms of the GPL, the
copyrights and change log are required to be kept intact (section 1
since they're notices).  We sometimes fudge around this if there's an
equivalent in the source control system (so the git history substitutes
for the requirement to add change notices and can sometimes be used to
remove change notices if they can also be seen in git).  There isn't an
equivalent in this case since the change log pre-dates the driver
addition.

James

