Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77DE248880;
	Wed, 22 Apr 2026 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776889813; cv=none; b=Wro4PU7Ini/WuBnPCIk86wV1o9BDvzlKTulGj9atsQMXYXV3UJBg4QhxgOqw730KBzqLTHeIbcn/nn4NeE8Db0NcltkX2TV+4EQgkuJowBpj5djoksmGvviJVpW+623tb19SdHlyrO6DwPlLIY9dfXJcZVjWbD/asWVYkDiS3r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776889813; c=relaxed/simple;
	bh=kkuD6CLCPtoN716whmYNyuZVzmjgZdWIkDMb+BurjU8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cldFgU00QUc2njIbgpDfBxFc6bsk2bj6KFvGF6yT1pg14dlwxij3iW5zlF4kd1JBkjoY/Q9jXOAtQRVdcgOKH5mB6RswAmRXmR/4U1pE3pcCjmiGl+9ypZYMN2umwJintgUNF++E5ch8XajXn86GKJyHdFeKs6SH9a0Ea3JIw2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HNCt/eZM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HNCt/eZM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g19nn1cZKzlffvg;
	Wed, 22 Apr 2026 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776889799; x=1779481800; bh=VZQPUhx+rXb0qQBkKzoRsQxV
	CKYwUq/JfEdgKMzTeTk=; b=HNCt/eZM92V4a8DUsj//sCu4BVDsEhMIQqH9AWxf
	A9dFwDjzecKhicDRODlprsewUD3xYpBqLhcykXGooDqbWvZW4KTXDDe6d2Drbez8
	9WpsCKdl+/Jj/eRaV13QthXvPnPzFNVZ2JGwraMMHd8tcYhNSl4c1Gc1yXXMifES
	db6PEK5zxfKV6Ytkf4zqDR3JStar0DXdOK7AxfSh1KyFJMd7qWlrMNNFcc8Lk4jh
	ghEEAEt848HZX4nw3Xh1n90K1T50fdoL1yslUTj9b8KYdLxp5pb7rN0DOZxKTSDc
	ImqYZpEoFytrKLhitP4ypYnIrE0Mvoll0LN+QsYfeJ5yRQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MpgyuWK0q_50; Wed, 22 Apr 2026 20:29:59 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g19nd4DxMzlfl5n;
	Wed, 22 Apr 2026 20:29:56 +0000 (UTC)
Message-ID: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
Date: Wed, 22 Apr 2026 13:29:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/10/26 5:24 AM, Christian Brauner wrote:
> The annual Linux Storage, Filesystem, Memory Management, and BPF
> (LSF/MM/BPF) Summit for 2026 will be held May 4=E2=80=936, 2026 in Zagr=
eb,
> Croatia.
>=20
> LSF/MM/BPF is an invitation-only technical workshop to map out
> improvements to the Linux storage, filesystem, BPF, and memory
> management subsystems that will make their way into the mainline
> kernel within the coming years.
>=20
> LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> subsystem-specific tracks, cross-track discussions, as well as BoF and
> hacking sessions. Please check out:
>=20
>            https://events.linuxfoundation.org/lsfmmbpf/
>=20
> for further details on the venue and hotels.

Thank you Christian for being one of the organizers of the
LSF/MM/BPF summit. Will a schedule be made available before the summit
starts? A link to the 2024 schedule is available at
https://lore.kernel.org/all/20240510212132.83346-1-sj@kernel.org/.

Thanks,

Bart.

