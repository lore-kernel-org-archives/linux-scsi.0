Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F5A376466;
	Thu, 10 Sep 2026 02:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789007325; cv=none; b=uh/m9fSOxa29rSJM7sudbp33flYuGzVtxBSxTGX6GPXYOz+Ywrwx5VkvWlfMiniebygAz7yUFO6/m3NPW3Y44YHuBREWImlb026Y/xji8QPm/JezN2YOLAxdHwvs8KgACfTELk5QM15m7jKQX+PMoeQ9hQaJWZOBvvte0XTepfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789007325; c=relaxed/simple;
	bh=TPwgu1FErKbIas7gxafPg8UxerOQ7Ekvk0PAW1SC+Z8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=fKOSEgZmL5pTRHmeGxoQzaKnsVArTH1fL5uyxMyBA7XXxfcvobSTJlJ3n2eXNxmtUZ31s7mkkGcIxLiuWAuvoLZ61fzfkSunkkmwLclRzDYy10may46WigoqXbc1YZHXOLOVgpOIfJ8DXUdQ0Lt63983f7WyK2IEyyoAmeBpb6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXuS0zX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXuS0zX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9249B1F00893;
	Thu, 10 Sep 2026 02:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789007323;
	bh=5lI1pfXv27hEAcXO9zU4jCeFqMc77ZvvDOYeI4roQZA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=BXuS0zX6HyLe6h+0fdcuJUFRT8EEaXVnLiiFr5g/FO8nqcoqdTXUhwSmavjF94wkx
	 8guFBL3TYcHxLaeZitiCjgEBhYurFDrqxBP5HEmUGHBjkcllZzsOJ5oZZuhMdLxMeD
	 P+te1Q7nbioR4q0IxGbCd524rH22iTEzXE/jg/GLcl4ZdiPADTiPwBziXcT0yZEcXC
	 t4b9MvqhNp83tcjua3YjFFcwBKcIkrIRqluEeSTWn0WQ0/N7XsjniL2Gixfn68JChT
	 3gkiq5F8Yr5a2+8KcWTj+KRFR6xd5T44VejcuxQIODVBaFejIp65zwTa9QubgM4UzJ
	 8r9os0r8m1b9Q==
To: Bean Huo <beanhuo@iokpp.de>
Cc: linux-pm@vger.kernel.org,  linux-scsi@vger.kernel.org,
  linux-kernel@vger.kernel.org,  MyungJoo Ham <myungjoo.ham@samsung.com>,
  Kyungmin Park <kyungmin.park@samsung.com>,  Chanwoo Choi
 <cw00.choi@samsung.com>,  "Martin K . Petersen" <mkp@kernel.org>,  "James
 E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Avri Altman
 <avri.altman@sandisk.com>,  Bart Van Assche <bvanassche@acm.org>,  Alim
 Akhtar <alim.akhtar@samsung.com>,  Stanley Jhu <stanleyjhu@google.com>
Subject: Re: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value
 and use it in ufshcd
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260907192140.2701755-1-beanhuo@iokpp.de> (Bean Huo's message
	of "Mon, 7 Sep 2026 21:21:36 +0200")
Message-ID: <yq1wlstalim.fsf@mail.kernel.org>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
Date: Wed, 09 Sep 2026 22:28:42 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Bean,

> The patches touch two subsystems. Patches 1 and 2 are for the devfreq
> tree, patches 3 and 4 are for the SCSI tree. The two halves are
> independent, at build time and at run time, and can be applied in either
> order.

Patches 3 + 4 applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
