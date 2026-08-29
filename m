Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D1B1643B
	for <linux-scsi@vger.kernel.org>; Sat, 29 Aug 2026 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787968663; cv=none; b=YOftBzxdVf4UK4tHYHr32Gsc1PAh179QLpNoFtK8PaZ6Bwkn/3QYuJPBZphthFQNXsRAgNDgEH2v2agu/ddpMBR1s0gajLuM472/+A4ViwsaqLBAIrpJ/poXSrCmxr/r2CyqFuWX9l/Pfiuct+17yYqxP87D5WypV44BBTnORjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787968663; c=relaxed/simple;
	bh=WNXYayDHzss5MuZfM0eISzxBLY9YTh/Z9zJzpfUHEro=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=ucXRfPVbHdQomiVI2BhnD4O8exIb1GkNxCMmOPC4iasb53fVpsAi0z3Vba8S4PR1Dk8v9aXn+zSTKpq0HdC4z2uq41JvqPosXtlmbdtdH21B2cPEudj2Ze02gVVQN6FswjIZAZa0uRGj9DEZWSs7gnyuphwf//6iSp/h4gEU+ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBJm92h9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBJm92h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99BF1F000E9;
	Sat, 29 Aug 2026 01:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787968662;
	bh=cJ+UwVZh7EgfCXPI4x3WINxWYmLZ8pDRkP64hlg3/aU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=bBJm92h9igsq+COVDd4JLUQMs6t5+7y+m28DToXpoxeS21tsji0cC7ZyLv4KqzH+2
	 Q+UH89GGp+adsLMyhH7JTPms7sp1VXsaDs8v70ZcOHEOXr401uWLpjU1GdySJHyocG
	 kh6AIAXgqag6k6Xl4XBOjgJenLUz8yaTgH8teL/kuN9apkhky1LsoVLD+KsFIciKmw
	 4NImMEsP/p0XoI/wBvhq8BNjM1EJVaPqZquqiCm4/ovUua0urKT34503B9e/6WqFJM
	 Qk767WsBMJ8SmNJAzvG8JorN4b8oBiEv7+Qg4RvuZXvl/iaT8XtSnJYd36EatuMVAP
	 XvDMV4ubuBw/Q==
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: mpi3mr: Fix error handling and resource leak
 in mpi3mr_sas_port_add()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260812103344.174247-1-mgandhi@redhat.com> (Milan P. Gandhi's
	message of "Wed, 12 Aug 2026 16:03:42 +0530")
Message-ID: <yq11pbhk7sk.fsf@mail.kernel.org>
References: <20260812103344.174247-1-mgandhi@redhat.com>
Date: Fri, 28 Aug 2026 21:57:41 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Milan,

> This series fixes resource leaks and potential crashes in the
> mpi3mr_sas_port_add() error path:

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
