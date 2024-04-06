Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E284C446A9;
	Sat,  6 Apr 2024 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712429501; cv=none; b=H+TiczL7ofHdGc+JakjrQO8aWh5muyxn3BD+8IFeaDorQEXh4xgFk16ilwaXHj9z/HFPIO04FnMjzqR9b7i/TFjt5fdANnu5SmTf9FZXPQUlo8meKTop1s8F4bUeErKd+EqqmT5EdlNoYQVES4K62uKVIHWMm4AMFkJHMx/3/f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712429501; c=relaxed/simple;
	bh=y4QekPwzHbQpnZEcbP06XBRzhYtTIB9g+/cptMSH16k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G0cgVIaw3ovrkF/kd8tl081NQctUi0r/fYf/6QfIQtgi4h9ijCvmb0JKTwR8mvL/JKrou2xgHDhc4kWFy/6doSaDqUEa2G7Y+FkFvQLMjbKFmUPNPPJYjmJc5Y6hW+QiiK2dVrRox7ZXMc+WYHa3XYZoXg8tAbBFDc0m9xwIpl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=lMGhj55c; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=ExR4CLOq; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="lMGhj55c";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="ExR4CLOq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712429499;
	bh=y4QekPwzHbQpnZEcbP06XBRzhYtTIB9g+/cptMSH16k=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=lMGhj55c+G6sXTkhJFAVQuv7sQgrn64xO9T8QV1zay2jI3gkHchB8cspR2vs6Z5js
	 kS+/R+kf9+x9oLq6OPtZipGZXew6oxL7qSLlOxN29HBK/nigHRdui0a7LZVgI3vXVb
	 YMfGZZE3jJ0/nQ/X+9GvQhQxM9uz8t4XFq3FMirY=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 31A431285D61;
	Sat,  6 Apr 2024 14:51:39 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id Fl91ak5xgcZr; Sat,  6 Apr 2024 14:51:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1712429498;
	bh=y4QekPwzHbQpnZEcbP06XBRzhYtTIB9g+/cptMSH16k=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=ExR4CLOqnoGJuGyNH0ABNUh0B3R4vvlLJF/7jcn4HJ/uxqzz3MOQC3G/dPUIK9aKv
	 zokToKefAahXarpGEu37X7WL6Hik2kOB0rXXM62wBR4UVn2F6AeSquavijHF3ARy1q
	 J25cdbwaU8Bqw741votLhBpVZferJBNuELyhuTcc=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6DBFF1285D53;
	Sat,  6 Apr 2024 14:51:38 -0400 (EDT)
Message-ID: <189127aefff8abdabd41312663ee58c06de9de87.camel@HansenPartnership.com>
Subject: Re: Broken Domain Validation in 6.1.84+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: John David Anglin <dave.anglin@bell.net>, Bart Van Assche
	 <bvanassche@acm.org>, linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Date: Sat, 06 Apr 2024 14:51:36 -0400
In-Reply-To: <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
	 <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
	 <db784080-2268-4e6d-84bd-b33055a3331b@bell.net>
	 <028352c6-7e34-4267-bbff-10c93d3596d3@acm.org>
	 <cf78b204-9149-4462-8e82-b8f98859004b@bell.net>
	 <6cb06622e6add6309e8dbb9a8944d53d1b9c4aaa.camel@HansenPartnership.com>
	 <03ef7afd-98f5-4f1b-8330-329f47139ddf@bell.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[cc stable to see if they have any ideas about fixing this]
On Sat, 2024-04-06 at 12:16 -0400, John David Anglin wrote:
> On 2024-04-06 11:06 a.m., James Bottomley wrote:
> > On Sat, 2024-04-06 at 10:30 -0400, John David Anglin wrote:
> > > On 2024-04-05 3:36 p.m., Bart Van Assche wrote:
> > > > On 4/4/24 13:07, John David Anglin wrote:
> > > > > On 2024-04-04 12:32 p.m., Bart Van Assche wrote:
> > > > > > Can you please help with verifying whether this kernel warn
> > > > > > ing is only triggered by the 6.1 stable kernel series or
> > > > > > whether it is also
> > > > > > triggered by a vanilla kernel, e.g. kernel v6.8? That will 
> > > > > > tell us whether we 
> > > > > > need to review the upstream changes or the backp
> > > > > > orts on the v6.1 branch.
> > > > > Stable kernel v6.8.3 is okay.
> > > > Would it be possible to bisect this issue on the linux-6.1.y
> > > > branch? That probably will be faster than reviewing all
> > > > backports
> > > > of SCSI patches on that branch.
> > > The warning triggers with v6.1.81.  It doesn't trigger with
> > > v6.1.80.
> > It's this patch:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=cf33e6ca12d814e1be2263cb76960d0019d7fb94
> > 
> > The specific problem being that the update to scsi_execute doesn't
> > set the sense_len that the WARN_ON is checking.
> > 
> > This isn't a problem in mainline because we've converted all uses
> > of scsi_execute.  Stable needs to either complete the conversion or
> > back out the inital patch. This change depends on the above change:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=b73dd5f9997279715cd450ee8ca599aaff2eabb9
> 
> Thus, more than just the initial patch needs to be backed out.

OK, so the reason the bad patch got pulled in is because it's a
precursor of this fixes tagged backport:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.1.y&id=b73dd5f9997279715cd450ee8ca599aaff2eabb9

Which is presumably the other patch you had to back out to fix the
issue.

The problem is that Mike's series updating and then removing
scsi_execute() went into the tree as one series, so no-one notice the
first patch had this bug because the buggy routine got removed at the
end of the series.  This also means there's nothing to fix and backport
in upstream.

The bug is also more widely spread than simply domain validation,
because every use of scsi_execute in the current stable tree will trip
this.

I'm not sure what the best fix is.  I can certainly come up with a one
line fix for stable adding the missing length in the #define, but it
can't come from upstream as stated above.  We could back the two
patches out then do a stable specific fix for the UAS problem (I don't
think we can leave the UAS patch backed out because the problem was
pretty serious).

What does stable want to do?

James

