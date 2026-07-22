Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9FD357CF3;
	Wed, 22 Jul 2026 14:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784730311; cv=none; b=KvlEHT7LrPOahao1f4HSsgCeIWvYW/iTjbkEE/TJoWkkK9kROSvTaGuUZmd4DoiZNEKLoSj6iritzN5aLs9RbS3HXfKAvhPgNh4HirI4ps0Yji91GbmvZgdHmbC75IUrdEgtJExKvu8eXGojcp/RbuNXQ6JdQQKL+Y77iNCHRbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784730311; c=relaxed/simple;
	bh=FDalG0oZKHUROtgimby8Kd9MgruBMWtm9RQfsUduxvA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f7lt6zf1iw8dL2Bf75nlrZqkwTOUuAA40gyYWLg1yILW2hriVKxZ3vsNx2rOVq7j9KO+Xc7lOrqNjzJitrQ1qQQdciLpxzPHXe7uz1f5oJTqA0hpMB1H5DS3dOas4kMYkphidXlm6Ppq66q8zEvKa8Lco61KlB2+VGV5OygqHrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bUw4crnP; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bUw4crnP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=b1yxWGv1znaHRbRm1RAajFXf2LiSVeoVCi7C7bYKF1w=;
	t=1784730309; x=1785939909; b=bUw4crnPJzA5g78rqm6CJ1Vyk29PExgJMLBEj7ktfHN6r40
	6SLOZvMKHRem/MNk28eqQlzVeVbkWWthltJFLEuXqYhryKhGTo5kKBJSIPRYtyBrEoCPJcwWCvWti
	jNFwfB1it5BT8VtretVjLz+yvM7SBjwt0tnqTd6W4sFgZ+Unpah+YYQgdL3Ylc/zfKNjZss7z5Fy2
	U2FroKCIoltcqpZeGa4KulqpiQ0XVSahf+ZRqZHiX373fCi0L2Mly0yVpbGPyFoTrvOCFc7AK3X9I
	Hi9Wd8mEK3sFY0fWW12rqrPssojj0QmAy5nuweaAfEG/y0o5OboYk2suwgD8Y1iQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmXsd-00000004oMR-3xRz;
	Wed, 22 Jul 2026 16:25:04 +0200
Message-ID: <96e5845db5e8e4f2d2253c2014b00d0db093ff21.camel@sipsolutions.net>
Subject: Re: How to fix problems with the sashiko review model
From: Johannes Berg <johannes@sipsolutions.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH
	 <gregkh@linuxfoundation.org>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org,
 ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 16:25:03 +0200
In-Reply-To: <5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
				 <20260722042744.5C1B01F000E9@smtp.kernel.org>
				 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
				 <2026072224-moisture-gonad-409f@gregkh>
			 <e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
		 <e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
	 <5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-07-22 at 10:17 -0400, James Bottomley wrote:
> On Wed, 2026-07-22 at 16:00 +0200, Johannes Berg wrote:
> > On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote:
> > >=20
> > > Well, I noted that in my reply above.=C2=A0 The way I was thinking of
> > > implementing it was to add a general instruction file for drivers
> > > which would make hardware trusted for pretty much everything and
> > > then instruct the AI to consult driver specific files for overrides
> > > to this so we could add the additional threat checks to usb.md and
> > > virt.md
> >=20
> > I guess it's a question which way around it should be - but I'll note
> > that generally for wifi customers tend to not trust the "hardware"
> > because it's mostly firmware, is generally buggy and can be attacked
> > over the air too...
> >=20
> > Personally (with that background) I'd tend to lean towards saying the
> > high-performance stuff that does want/need to trust the device should
> > opt out, it's harder to get that wrong. If we generally opt out as
> > you describe and then forgot to include something, we might have
> > issues.
>=20
> So this is just an efficiency thing.

Yeah I see what you're trying to get at, but I guess I just disagree.

There's also a risk thing - if you erroneously get a report for SCSI (as
you did, IIUC) then you can opt out at that point and not worry about it
again.

If we erroneously _don't_ get a report for something that didn't speak
up because they're not on the list, didn't dare say anything, didn't pay
attention, etc. then nobody ever knows until someone starts exploiting
it?

> There are 144 driver subsystems,
> so if most of the want to trust the hardware it makes more sense to
> have this as default but overriden by subsystems.  However, if most of
> the 144 don't trust their hardware then absolutely, I agree, it should
> be per-subsystem opt in.  Part of the reason for the post was to gauge
> this ... and so far I count three opt outs.

Well, you could also argue that there's one opt-out the other way around
so far (yours). You're not going to get the full set of information
required on this list either way around.

Maybe all that just means it needs to be easier to actually decide
either way. Doing it in the kernel as Greg suggested, would perhaps
lower the bar vs. some external Sashiko contribution.

johannes
