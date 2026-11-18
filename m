Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977422;
	b=4lC3UDnA5bMB5PqJq0B66vfnKvUMu5hckBWBb6XcomdKwrmMWmQMN/snX6+OFjRzfpMI
	 yzt7w5yPaj50DSkzAmJ63mdTGtlJSoMAJ9zHKAeELUbiLgMEAmxU40vw6xSnYYar1jLZX
	 nj8942Sxf1zNXyv8ep7cifBzHuBxvoehAIjOf8uuyRfApmbslCROvTNwYsGc7PPeyV3E1
	 m8wfiOBNlLMKsZjYn8Wlwo2j1DsTUIWe58hsB66G0hAv6DyJRWl1Yw9PM7YcN6nhfdQTW
	 KoGEFeVmI1JHM//qTUdTYw964EW9OxEZ5OXAoyWOkIaspaM1mC9T6mHE0kL4rZae9mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=KLr2357QtwPayuJ9qgsDdzYy6ahCshvnbo9ZedK21hg=;
	b=aja6w0+ylHv05HTvN9bDkAkf87dcDfuViGEP9Lu61VIpNAc91KPZI2gahMFrt+CWL6bh
	 e7XPCuE+2DNycxQp+jamAep/4i0rVRZIL7LYSkEqyowTlBzZRbAnrx43MGnxmE61pGAhi
	 z46R/TVhqiYoEjDKMS2f615d+Fn3OizkyKtTYjjp4ecXPvHcrDJjDpgkgRvHdO0dDisxJ
	 +C/Xhc0lPlgLZXVEqnDxV+xnIF6n4Nwgb00hM3HeTqHjXqjXTKeaW+8q5aE5md92izf3L
	 UFUhpAZMRvgs/wEHgM/A1yJM1jBmWORmm1jyz+G1Od3D4lD1dpyxNswoezdnYK8OyqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EjMJWijY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A00606A335;
	Wed, 18 Nov 2026 04:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EjMJWijY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F5D1F000C9;
	Wed, 18 Nov 2026 04:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977422;
	bh=KLr2357QtwPayuJ9qgsDdzYy6ahCshvnbo9ZedK21hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjMJWijYYg+aDhd/AuSiEFihWR49y+T7hfjsoOepwe0uWHQwumFpPkjq6xJNpPles
	 iDK+6nhIHmogci1bPm4UtAwYZybnYM465YGYJ2ybOn3GDSR7HGHU9lQK5qbozVQfUm
	 4CAs9fAbkSVFg4QPX8UeLsitVNyfYTvpQ7Ye+l53hnMlqg2a2kyNWZFLSQZqRq2Qcs
	 VKa8D1/+vzJBzkaX4xQvQ9AL6jrwMkrKufEeexU/fS/kWnCkx+ai+GeymBn/kIiEkT
	 UXDBZjbR8Q/6bfR0ytwVHAajhzn1dfmX7O81CNPLurVXcqS1GyxeOk9fjMUix1ZQOC
	 AEMTW8VAqgIig==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	shao.mingyin@zte.com.cn
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@HansenPartnership.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] target: remove dead kmap checks
Date: Tue, 17 Nov 2026 23:50:12 -0500
Message-ID: <179485091823.1479907.3925864868824077096.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
References: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 05 Nov 2026 19:33:46 +0800, shao.mingyin@zte.com.cn wrote:

> kmap() and kmap_local_page() never return NULL, so the checks after them are
> dead code.  Remove them.
> 
> No functional change intended; both patches are independent and can be
> applied on their own or as a subset.
> 
> ---
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/2] target: iblock: drop the dead kmap() NULL check
      https://git.kernel.org/mkp/scsi/c/63d67440dc9f
[2/2] target: core: drop the dead kmap_local_page() NULL check
      https://git.kernel.org/mkp/scsi/c/0fc91e802801

-- 
Martin K. Petersen
