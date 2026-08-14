Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3623D5237;
	Fri, 14 Aug 2026 02:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786673865; cv=none; b=FrQIwfOXi3zZCXxrHh21WsIXL0HIBdKIh62w/JDWYF5v0z4VlN76LRR20tPfBcnhQE6rZT/21A13iFeiowMv0Dr6Zs0kGXh3hOV663w54H29z2PKOz97XUHfLYtctQfGaeA9AJcU4V8XgoYw0awv5wkzSQvfwGGkByf7SxXXYmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786673865; c=relaxed/simple;
	bh=gJlURUFv0/k4qAcOs4mHKqrcaR0fNTrmDZRwObeGQJ8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=DxbsQAL4s26QtqA0nZXFs8PWyi0ikzTGF7XZdtwwwbtd7nF9bPenqGZYlJR2UJftzDrHZoSpnZ3HYnasJVa3rVwAWUlnWMTPaEVwbny22kStGjNB7QFvVaQ7B1PS2Y3x7E11JGMXFCDo609dck20iVCEAjeQcIuPiOlg8NwH7bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqzMuqpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqzMuqpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7D01F000E9;
	Fri, 14 Aug 2026 02:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786673864;
	bh=psRf2Ib8tVJDoARQh04QMVv/glXCjKEf87dBT89jdTU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=MqzMuqprqj/wHhfhcexE2pEZy/D1VCSm1GY+ZP1Mvfk07Unrm42kbW4XhF0vrWX7h
	 BS4wcNVfs6ikuiuM41UG8O1SiRaSHRC82YIjba/1SIKj4tYfj52yJ1nsR1CAJcz49K
	 ilq/5hrx0JNg8NRgN/ayhmdkU/63iSXIKIpOaJ6FssCgKEARZKLQnAaJlbN803EvHU
	 NfWUfnPQ6D7G08McCctCrmrj7vxHw+FKhUU1/F7FCO3sQNpY1izLoz0NDP8IQJ5H7Z
	 /4AhrWbCagkD6ZkfD2PMz9UFTj9d8kKdYul9eS/JyvXNXi+YSvVDA4d/3EVyGtMY2/
	 /mP/GZ+jpB2Mg==
To: Ian Bridges <icb@fastmail.org>
Cc: Justin Tee <justin.tee@broadcom.com>,  Paul Ely <paul.ely@broadcom.com>,
  "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin
 K. Petersen" <martin.petersen@oracle.com>,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-hardening@vger.kernel.org,  Kees
 Cook <kees@kernel.org>, Nigel Kirkland <nigel.kirkland@broadcom.com>
Subject: Re: [PATCH 0/5] scsi: lpfc: Remove all strlcat() uses
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260729144617.1388646-1-icb@fastmail.org> (Ian Bridges's
	message of "Wed, 29 Jul 2026 09:46:12 -0500")
Message-ID: <yq1lda9tpi8.fsf@mail.kernel.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
Date: Thu, 13 Aug 2026 22:17:42 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Ian,

> In preparation for removing the strlcat() API[1], this series replaces
> its 81 remaining call sites in the lpfc driver. The sites live in nine
> string building functions across five files, and each patch converts
> one source file.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
