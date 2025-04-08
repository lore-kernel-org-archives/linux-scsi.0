Received: from bsdbackstore.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA8C2620DE;
	Tue,  8 Apr 2025 07:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744096697; cv=none; b=JEq+HE39l6+ATxN1sKsqTvVvCzLp+lpoxvyPMlgM/kyXBohd3kFa4AxkA/DPFATFHuWBO5WDiFABnaJHNTYybwJD53FHidXBGPS4+iyrLaDD/KXkgLbHvHWwf+MvDI/Ja20STJDn2VkERb04o97CCckh56W6Myx0J/JjJR2xZJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744096697; c=relaxed/simple;
	bh=0HQJ0uhZipCImvUnh7JNZ32jeyceM6KExmIUVlHZQsQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=ePpYW1CZVMN25ojAm9FuZAr7kvMmL1gRm1I0FVMgfIVw2LtdFzcSh2zWaocQ33j1yIbzWMgiNhCvoRwur5sDkoRYqYO6fFm0AecEkomijUWQW1lHGgulifjv6PSbgJJVrmGytwSc0a3EyDQhjiSWs/adTpPdEe5/EiTC2xfJUFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu; spf=pass smtp.mailfrom=bsdbackstore.eu; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bsdbackstore.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsdbackstore.eu
Received: from localhost (<unknown> [193.207.154.230])
	by bsdbackstore.eu (OpenSMTPD) with ESMTPSA id 3acd0c3a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 8 Apr 2025 09:18:10 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Apr 2025 09:18:07 +0200
Message-Id: <D912OCZ7ENI8.1WB0CJRYL7LRN@bsdbackstore.eu>
To: "Baris Can Goral" <goralbaris@gmail.com>, <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
 <linux-kernel-mentees@lists.linux.dev>
Subject: Re: [PATCH v4] scsi: target: transform strncpy into strscpy
From: "Maurizio Lombardi" <mlombard@bsdbackstore.eu>
X-Mailer: aerc 0.20.1
References: <D908SSFL0E9D.24WXC0I3O6AQB@bsdbackstore.eu>
 <20250407174854.10132-1-goralbaris@gmail.com>
In-Reply-To: <20250407174854.10132-1-goralbaris@gmail.com>

On Mon Apr 7, 2025 at 7:48 PM CEST, Baris Can Goral wrote:
> Hi Maurizio,
>
> Unfourtunately, in version 6.14-rc2 (and also v6.14) strncpy is still the=
re.

Sorry, my mistake.

commit dfb7df1ddb29c89662e84b2c82c1ff7943358ae0 that replaces
strncpy() with strscpy() has been merged in kernel version 6.15-rc1

Maurizio
