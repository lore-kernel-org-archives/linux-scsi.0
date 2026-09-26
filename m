Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520B02D0C72;
	Sat, 26 Sep 2026 02:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790389377; cv=none; b=WqeD4UN750RKkl37QcvurrL4sfiLxJzag2GyR6SI1xBfFoXvewzoADIE3vvMGa1g9/jXWXkPCyXXK53jZx8NwAZyJoDtSBp+JRLy3/Yet1Ek4/RSfmcrAphgnOGd/V2j4MCEaqDCsRtuKrtgRlUfrhN3lFgrDRr4hTsuQjVLKFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790389377; c=relaxed/simple;
	bh=7lV8lB+eDKfddlVyYrPDYjVRUfc2tsKbzpW6XU8H4sM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=LAd+U83eXCxnsWkwX+onAC+wypn69Bzkm+UUwDAsOPTRmFDvnOmenFToysHDUeNXgX0JBPCjGLtYjZv7CCOPizcuYz/ti5lWGNWy5VSzv0Ntb9wFUDPBrXCKYLqcwdHDs51hQQ5EHZ2OWHHmmHXOGsQYD7nmNoeN/Xg54VXXxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ywa2wW1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ywa2wW1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4191F000FF;
	Sat, 26 Sep 2026 02:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790389375;
	bh=yZTdIPdPfMDHMRHRz5Cl7wvYuL+ZBG2t1H8aEwHx0zo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=Ywa2wW1BTsIX7dV9lIDS4Jk3au2BgWMEs7ApVNyaML7ZcUn+hljpWzlBD+DGyPJZt
	 KIYgKo/hUe6qzT7VYH1cBcStEaKV4H9L52L2BvGjq8xwuuh05WIM3EzF0KJsxBqsOc
	 sTXJ7Hg9fcCc/aKCHxnpXlXdzGZ9XNccbhQeyokmWStjocuEOrnu+d+loMiU/Lj5nx
	 +qNhnoQ9TmHnG65dd80uc3rKPmBrWS2iBaT1AgGOe+P7zpuJ5T08oVzyja7DPTDv8l
	 74ptLAHfdmVmcW4xvw3g09YGBkC3fMPPsE1NpEOYWG3CYjpLIN0VhmBqocWmnBYI5y
	 cdXar/zhRu+kA==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: mkp@kernel.org,  James.Bottomley@HansenPartnership.com,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  bvanassche@acm.org,  avri.altman@sandisk.com,  alim.akhtar@samsung.com
Subject: Re: [PATCH 0/2] scsi: ufs: core: Handle devices declining optional
 Query IDNs
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260911024319.1346706-1-stanleyjhu@google.com>
Message-ID: <yq1pky0px8v.fsf@mail.kernel.org>
References: <20260911024319.1346706-1-stanleyjhu@google.com>
Date: Fri, 25 Sep 2026 22:22:54 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Stanley,

> JEDEC JESD220F specifies that a device which does not support an
> optional Query IDN returns QUERY_RESULT_INVALID_IDN (0xFD) in the
> Query Response UPIU.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
