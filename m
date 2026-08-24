Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927FC22D7A9
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787535163; cv=none; b=jm+CUUtrYuemckIHv+9lHOHV43cEjOte4S88axcFtvI5bVhULdH1ye6GON8miyazg5Kr58Y/e43ZYxDKGq87rAyqeCcVSki9Zbet6xBJZGCHGNwu/7f2GaAXoEi+lVhZntlxrdJ/mpQkmKdt0tIWQlEbATFbVRUu7/xQ150gLqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787535163; c=relaxed/simple;
	bh=N3Dt/FAVDHQ3AdBhp7XKwHBEi81otjQBgc1Sp1beMAI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=esnlY9th8GE+93MlyvdojSsASff9ghOamSZEJnwYZi5nVSl73SdMvoG0bonzUdoz51/HxUhB6FYAlt0L1/g2z6g7/BrnAW50wMTR6Tx9f3t0avb1mnz2bvrgiV336/Sq3sCYIn4LRktBFpx4o6D9NGBKbmpCEw7AGqDRupMXXUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccUwOO3B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccUwOO3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFFE1F000E9;
	Mon, 24 Aug 2026 01:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787535162;
	bh=XLLAw1mmQUqMaa++Kupa7NeJpJaLDfnBrAxQVYwTJ1c=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=ccUwOO3BfGzudmTnu8L7hdNL0Vle+WXxMQrbmDe1l4Y9/lz5rS4Q73B4dyOqaBcbV
	 iD9DfP83jlUhMZrTW8Qfhckai5Z2oU0M+RLxHccx7ecy2q/SR0V0rDqBV12uh2zMdY
	 Y7RafOHxuttcY3/KGLdxPNxD4815Vq7VfYCFNeJ8TlXxnHix1wktpUO1VwzFdhwxuW
	 SaKh6EKPIazNWRFSxTLyOW/IOSpAg12uJq2kCfLmkn6ua2V2lxn+rkmInRDParqxq9
	 ajk4Dn5vqgVrB+iejm9sro6raLfarOrrBBGsbnSwdhuufr9NA6aEHXC2gJC/EYIM+m
	 DvCMYUyuAcLZg==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  John Garry <john.g.garry@oracle.com>,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen (Oracle)" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: core: Enable context analysis for hosts.o
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
	(Bart Van Assche's message of "Fri, 14 Aug 2026 16:20:08 +0000")
Message-ID: <yq1mrucpakw.fsf@mail.kernel.org>
References: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
Date: Sun, 23 Aug 2026 21:32:40 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bart,

> Enable compiler-based context analysis for drivers/scsi/hosts.c by
> setting CONTEXT_ANALYSIS_hosts.o := y in drivers/scsi/Makefile.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
