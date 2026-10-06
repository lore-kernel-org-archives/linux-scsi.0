Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5891F63D9;
	Tue,  6 Oct 2026 02:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791252450; cv=none; b=lqzmUWVQdleWhDY2bnjRfT9r4qZvNA7rS1KODRN9HqS+vO4JyuWesTxj+iB7g9W9/TwN3bRGv8NVLupIc84C6zEKeT+l8Bi1JS68jxwBuBoU1A9JQ9PgKstx9uLi4CEKVyfwfLNkMXyhOpewObgbzfOxGcvBY55k8XGu1g0SuC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791252450; c=relaxed/simple;
	bh=NQSHxTDeaTyU2/KAXe5VUnqwb7c79Y+CbS/kvDiH+WQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=giXayvelwoGFvtSbiWAN121tlLRmpi9hYFwg1MT7fRAX3CISHc2gAs9rejNdeoLnyUNCRpNWNFuSXf/Aeh/TNMxF74ZehBNapuaDaJ3RM+E54B4qUQcVR0Wo6stI4v0chc2Ache3tLyFtZ0QPsCGWZkNMZNmRwer2FJUylHYGfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beDJ31fl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beDJ31fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D831F000FF;
	Tue,  6 Oct 2026 02:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791252449;
	bh=CjzN8u937NLCldYHsScF4MaqvMc1CgCt2oXYJwb8zpo=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=beDJ31fl6O+uT7g8KUEFbztjYkUcjexufJTMLuRxuQLfUvsXY/ZiN4XOqNd37FSeB
	 GwnehX/nr4b9oyaracuybs9gjrPriMfsVpo1c0XMHxTKBuy/WZbwU6GVdc5DnBGkam
	 /R5O9vu/qV9VWpJZzVtACkC5FlNFA0dTmkHkObuOxCw1vAAFQm82V+tjHrfhRfWRO7
	 lSvOUr9ANZXsGGRfLOojRtRk9qu1NT2Tac4w71e0Cw6GUbuS0xHX0UiJ9Ji/44yZNx
	 EpmnDEBqd5N6cdK5D4LBjz0DuYNJ3OrYKh/VyHtlfoqBARjwmG4KAnlLxrXekWwIPr
	 6sDtGK7Lb8mXg==
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>
Cc: anil.gurumurthy@qlogic.com,  sudarsana.kalluru@qlogic.com,
  James.Bottomley@HansenPartnership.com,  mkp@kernel.org,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-hardening@vger.kernel.org,  morbo@google.com,  kees@kernel.org,
  justinstitt@google.com,  codemender-patching+linux@google.com
Subject: Re: [PATCH v2 0/2] scsi: bfa: Replace strlcat() in symbolic name
 construction
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
Message-ID: <yq1a4ork2ek.fsf@mail.kernel.org>
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
Date: Mon, 05 Oct 2026 22:07:27 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Mariia,

> This series replaces the strlcat() uses in BFA symbolic name
> construction with snprintf().

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
