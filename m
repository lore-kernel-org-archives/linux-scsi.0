Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B872FBE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 01:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789609661; cv=none; b=YY1U8EYlu+CXcPQeq6Ax+at3Y9MQKc10vBmhJ0D+JNeGmRf2BJ2zAuaawC9eG1+DJPy4GFAQDVu+ofO63S0qhjYxMwOVFdnhiYyjIiGU76+9AqBU4fyg0isCNxBF1VkLzgOFDIyrxWsLDuKfhSuroawDLWQB2L6g65qjoaPqmSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789609661; c=relaxed/simple;
	bh=NLWT5JTYYL6P8nzYXfo/ru1DMQd9Pc1Klzc8dWCV46c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=jtMcI9M2KaAn5XiCL7Pf9MUR9V5D6vtGC/kKHHPiZQ/mLj3yh9h1RumklhMGnnQs0XpCO+jaoy3adg+YWxaW06StSiDDaqDTcEqCRx4AT77m8lHrVN0WgT9M2uz6YcL9mm2D6rUp1WDaSt5mHJBTxMZy59H/dX/98SV36neQTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IuUtyPv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IuUtyPv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED4D1F000FF;
	Thu, 17 Sep 2026 01:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789609660;
	bh=UXuhy+pJZQ7PadWumO8xM5E7XheODBfRsLzU/D16leg=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=IuUtyPv6ihpFlwz0hnM27lS0ClgZZsYQud0e2Vg5ktjacKG+tkEykEuHWkjG/+2IG
	 iknsCu3H9JOkgfjoRHQX7VHvHgrlRm0B2AdtGl8gTtd0mwqYc+GBRWtOtePO0SM8jM
	 1k5LeE3qQDZ5LF0q/kZQb9FG+EV/nrQNeGeCZviZd2bqTuCMCBC5s7OtAp6qGCUtL2
	 fnW+Gt0lQd18U+67qX+Bv+aUnMQWf9nxVbnzpnOOukVqWT7LwcVqQXmaJoiz27psRY
	 WqwBQ4lSEW2BRNiesUFppajOBNjJs2BvH7hm5amP3LLO7TsaIQ3C97MS7ah7fqZ1gU
	 ZKNqeOUHD7+2w==
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: Is anyone using ACARD/ARTOP SCSI cards?
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <CADkSEUjRczET4zoHo944F-Tj=bK5w_SbSzwPoSfKh5EOniEhRQ@mail.gmail.com>
Message-ID: <yq1fqz8veyy.fsf@mail.kernel.org>
References: <CADkSEUjRczET4zoHo944F-Tj=bK5w_SbSzwPoSfKh5EOniEhRQ@mail.gmail.com>
Date: Wed, 16 Sep 2026 21:47:38 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Ethan,

> drivers/scsi/atp870u.c is almost impossible to understand, and thus
> unmaintainable, because it uses magic numbers for all access to
> hardware registers. I would guess that this was done intentionally in
> a misguided attempt at IP protection. Is anyone using ACARD/ARTOP SCSI
> cards? If not, the driver should probably just be removed. What do the
> maintainers think?

My last user contact was about a decade ago. I suspect we can probably
retire this.

However, undocumented hardware interface aside, the driver is simple
enough that it hasn't been much of a maintenance burden.

-- 
Martin K. Petersen
