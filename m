Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673D657C9F
	for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2025 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745705919; cv=none; b=GAi6u9X35IHclxhzBUVOxdbaFIaDmBPjNRyMTEcMhuaAFVwv+lOamGKif5HkdmFDtTNSFTW9cYX6Iu9E8TnEUDdW3oA6sYm7aLiLbqKBkXaxr0U9MkMUKU129goYaHxZQQQka1KyQU6qn3bdgnkHhP2HIkBmkBXYmooot1yWTbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745705919; c=relaxed/simple;
	bh=L4gkS4SqHbozZjPndQFJnzP/5EcGnIBuGjYp1m+AhIo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fFWSbkcfhHtfL4+P3ddc+ca2hJXWNBxqPydoSk6GhTnS+3XFUJVcgkqGwuohkRi3maeXtVwq13uprFrNqLPF3F+kXx6mVuIsIguKKyBkReV45c9GNwK7TmvPsYkOs3+iTcV9bk0mQx2KbxJ0DtAhKS7Xa1BbZ77JKVpcQJsSudU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LQ4Id1Ws; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LQ4Id1Ws"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745705914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L4gkS4SqHbozZjPndQFJnzP/5EcGnIBuGjYp1m+AhIo=;
	b=LQ4Id1Wst6UwbO5njTYFjmH0ClEbBtzJ6MuEdjyUP2Gl8yxI6QQlzbg3e4eoASRUkD9gLP
	hFUNSEnEmcKq6B3pr6c/4ZyktjpSMMAkMoQiv+Lr/qFdgio7qjh7ZiRXUSzjJFrvXta8X+
	hkLgET+VEy0rwwWAUfEw3e30DYoeJ1E=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.2\))
Subject: Re: [PATCH] scsi: target: Remove size arguments when calling
 strscpy()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <CAPj3X_VKZz_8oq0puSuh96_=ozR+t8xL_whb5+UaNYS0MOrpKw@mail.gmail.com>
Date: Sun, 27 Apr 2025 00:18:20 +0200
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE594AFC-B626-4051-A4EE-01E3796145A2@linux.dev>
References: <20250304181400.78325-1-thorsten.blum@linux.dev>
 <CAPj3X_VKZz_8oq0puSuh96_=ozR+t8xL_whb5+UaNYS0MOrpKw@mail.gmail.com>
To: Lee Duncan <lduncan@suse.com>
X-Migadu-Flow: FLOW_OUT

Hi Lee,

On 26. Apr 2025, at 23:24, Lee Duncan wrote:
> Reviewed-by: Lee Duncan <lduncan@suse.com>

Thanks, but this is already in -next.

=
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit=
/?id=3D1f8eb295790001e0f498e62c186130055d3d496f

