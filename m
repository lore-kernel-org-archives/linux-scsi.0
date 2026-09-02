Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C582630D407;
	Wed,  2 Sep 2026 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316965; cv=none; b=neqA24ON1/7yORk0UKBxxY4mzg7V4ac4z3Gy4/tXg/TaKpp1rCNdvgq6SBEpg6CRuPz/86k/dZR6DtjPFr35raKJCyfW2XjUtnUsc/x4Zfdf7NGyJNUnkzhthDzecoFbg6MnDWwzZn3UiBjuRB7eLzq0bQbHmSsKmF/C2O/g2f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316965; c=relaxed/simple;
	bh=mwUvtCF20hPyTH3YZgKntSV18xdWLQ1UEDeogvXwaOU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=Or16TPjYyp0oadEHUDxOh8FOpFzzPhBRzfk+z9xaIkeoFJzp4EOxQ4e+dfCp9mfCic6C6Os92MlFYFUnAJO54GXhfqFf7ylLht3n+PIcq997G3nvjCE620ajVZvYB3rKDxgsx2xk3YRURCa8XLx+whHVRa0aUD2MshpW8jO+5/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAjcIJTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAjcIJTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719FA1F00A3D;
	Wed,  2 Sep 2026 02:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788316961;
	bh=MDrYntgOMTi6ocL58pgFzcqpX1F+wE38GAJwY5mRR+U=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=NAjcIJTOBEMoOM+34V1M1t7rYDhsQzsY96Oxt+/8fXjZU1EhQvItzc1Awvskb+uqa
	 IfH+TtD4vkldHbquzgnKIdU/H46+2e7MDI5BGBZ6sMSMoeE65ZASX8WMy7r1/0KTcC
	 ZyUEmns5GwM1hUatKb/dMCiTNqErX5QiV4pY/FG3oQNE//88IsBUMBePyYhIFHjnPI
	 pMPLShAe8/I1+U3pilyXXVDbwOiF+b2bidtyWbVg8CnMuxs+xJQHOfyt2YL4z/CbiC
	 1lnvMdRXSd7wCe6IKv33wukxGW2P9k4Aun1S3TU+pFdXG46uz/ODPuU6jyQcR7rIRq
	 ryTr11LLdMbeg==
To: Mike Rapoport <rppt@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,  Brian King
 <brking@us.ibm.com>,  Hannes Reinecke <hare@suse.com>,  "James E.J.
 Bottomley" <James.Bottomley@hansenpartnership.com>,  Matthew Wilcox
 <willy@infradead.org>,  Wen Xiong <wenxiong@linux.ibm.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-scsi@vger.kernel.org,  target-devel@vger.kernel.org,  Hannes
 Reinecke <hare@kernel.org>,  John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 0/4] scsi: replace __get_free_pages() with kmalloc()
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <apK13danJIU2PD8f@kernel.org> (Mike Rapoport's message of "Sat,
	29 Aug 2026 13:35:09 +0300")
Message-ID: <yq1se3sfk71.fsf@mail.kernel.org>
References: <20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org>
	<apK13danJIU2PD8f@kernel.org>
Date: Tue, 01 Sep 2026 22:42:39 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Mike,

> This seems to fall between the cracks.
>
> Do you want me to resend?

It still applies. Now queued up, thanks!

-- 
Martin K. Petersen
