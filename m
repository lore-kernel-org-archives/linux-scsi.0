Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2BA3491C9
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116182; cv=none; b=DxeF77bgZerphXa7ppzXk3HvtZrJ5NNqznKDkg4AYQPZL4+voK+0V3OAywB8lgWL6FQIfKaBtbh8UhuxCgNxFav4d1EzDRL1BYjwm9wLZSm2/TRrIGLAy4193FCA+7uwGKu8VLTnCXjAhNFGADzbcY05oRLPg8U44esthG2g83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116182; c=relaxed/simple;
	bh=WnpxiAeTDmVNZKwKqn9GpQHnszX9V3ivyWtE0FjN+V8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=OdqmNGHYYdLlyyHYjnposJ+2HKzRRPCbw6BPMZJpyw+yzp61AClCBLegGkP8uxLGpYRZI375nMqgTBirS1DxR23XEqCpVRzfI5Z40SCYKynbiVrUTCpU/YVTWjEgeTJwzq0FWyOvg3LNm/Eu2Yxk4vSHbKupwQobzpf8ZQTHv/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L//YX1ua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L//YX1ua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C941F000E9;
	Fri,  7 Aug 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786116181;
	bh=HwvHSMUedISDWvqtOmKXV/sISoaB8dWaxUaDtL1ZPsw=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=L//YX1ua4RjIEGpaXZWm6GduVae+thdwPiIRopWXdMZOqJKkm2ck62dAJKy7V+YUs
	 l8lpw8ifqjEdWVuiIjdgbuI6DyxhqR8tVW4bqErb9lYB7w2BS9yu7IYkXi7Dyo2RRW
	 6iNvIlJO2KJQuTmN1i0gIgA3xjHZsErxM2aGn7/HFcqqQA5fc0GdVIstwD0or/rxyK
	 pom2ko1NuvmGn1/kSH/dc66L5aJoFgotBLK5nRb86R/yFBtibOoJGE+9AyprP8cLxm
	 ysbelNo1f26zp/GFbrotnSC6O7RNo2gPVj/i9i86nGPPMSssmmf5v23DoSjQb1txLN
	 +P2kB5DaNkYPA==
To: John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@HansenPartnership.com,  martin.petersen@oracle.com,
  linux-scsi@vger.kernel.org,  hare@suse.com,  bvanassche@acm.org,  John
 Garry <john.garry@linux.dev>
Subject: Re: [PATCH v2] scsi: alua: Use access state macros
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260805145906.2825553-1-john.g.garry@oracle.com> (John Garry's
	message of "Wed, 5 Aug 2026 14:59:06 +0000")
Message-ID: <yq1tsp62c6m.fsf@mail.kernel.org>
References: <20260805145906.2825553-1-john.g.garry@oracle.com>
Date: Fri, 07 Aug 2026 11:22:59 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


John,

> Use the SCSI access state macros in alua_rtpg(), which is better than
> hardcoding.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
