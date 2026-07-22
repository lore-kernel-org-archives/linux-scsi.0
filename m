Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98323440A22;
	Wed, 22 Jul 2026 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738227; cv=none; b=UioUKMwslUP8q0gGWGYt7/FyORamMVUXWE/xgfMt8AEbA3DAtUoS5TlQ3hNqmvGqLxH6hvP2Ro0XaNwmvEyqJbtduglhbJjJns6Kcu02tQHAjrR2XYjjnLEOabJY3ZL8L2shwwRuv+7r6xr/MciOfEFlMTwAevhfbfmRnx40sSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738227; c=relaxed/simple;
	bh=ElJIkxC8AthB5mB0m1SeZ/AYKG+86wnnOzfNz586z1c=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H4qK96Rgbk6WFGJis+H5VcfoVJJ0bCyTSo2/+cmyRkPK2R/Gt+qul5WCkCPDRgZcylD6MIXGvND9lPdQZp614kmeiw6Ct90il4Q0fDVJ4ogWgdf/fdvcBDHhIrqgPT/jCZJDRGv8NALsE0bg2oIDWM28Gn4D+DZGO9a7lv5r0sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=YIazyMzF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YIazyMzF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EBqX5pdMkU+H5JWqzQkskrnKz2Nw37N4ACtfdQBVWN4=;
	t=1784738225; x=1785947825; b=YIazyMzFfhBrzDcJGmexC/8h2f1xVCoXkBmRk1bO4bCKjNH
	CPFgQiosHSuoEuyRjPz+3pGrPA6JUIXZTkPUlaRsC/Sa5odkKbqbzgP4mMHxwtUlh0tbjRNasVtkt
	g+e/9j+JQsqvo/yDJpm4c85f8Csbr2wi/BMsSgETN+va/MePpkz9VcoZP1byUQsZ3+LJ6N9U8bLE9
	jupVxGi80A3n9vR6wY8BgGpu0dxAlh4dhTk+UPzWqu17ibl0aIXSBIBRNgynUwVAh114S8ptSFVPQ
	8dTQbMQeD27N6HzpRCA8/tRj/go1PtXbtHrfJvUqQKtqCG7JRSvUfa4aw0EGYhUg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmZwI-00000004tDI-1MC5;
	Wed, 22 Jul 2026 18:36:58 +0200
Message-ID: <6dfd1e178392f3ef1018f693e209025300280007.camel@sipsolutions.net>
Subject: Re: How to fix problems with the sashiko review model
From: Johannes Berg <johannes@sipsolutions.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Steven Rostedt
	 <rostedt@goodmis.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, sashiko-reviews@lists.linux.dev, 
 Chris Mason
	 <clm@fb.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-scsi@vger.kernel.org, ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 18:36:57 +0200
In-Reply-To: <9a107be6c6041e3ce892217096c8fba7c9489849.camel@HansenPartnership.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
			<20260722042744.5C1B01F000E9@smtp.kernel.org>
			<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
			<2026072224-moisture-gonad-409f@gregkh>
			<e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
			<e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
			<5a2ce0b0eab27354d62450018f9843be83c72697.camel@HansenPartnership.com>
			<96e5845db5e8e4f2d2253c2014b00d0db093ff21.camel@sipsolutions.net>
		 <20260722113904.38fa087b@gandalf.local.home>
	 <9a107be6c6041e3ce892217096c8fba7c9489849.camel@HansenPartnership.com>
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

On Wed, 2026-07-22 at 11:55 -0400, James Bottomley wrote:
> On Wed, 2026-07-22 at 11:39 -0400, Steven Rostedt wrote:
> > On Wed, 22 Jul 2026 16:25:03 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> >=20
> > > There's also a risk thing - if you erroneously get a report for
> > > SCSI (as you did, IIUC) then you can opt out at that point and not
> > > worry about it again.
> > >=20
> > > If we erroneously _don't_ get a report for something that didn't
> > > speak up because they're not on the list, didn't dare say anything,
> > > didn't pay attention, etc. then nobody ever knows until someone
> > > starts exploiting it?
> >=20
> > I agree with Johannes here. It's one thing to get an annoying report
> > that says "You can be compromised by your hardware" when the hardware
> > is trusted. I have the same issue with boot parameters. But I rather
> > opt-in than have the case that I'm the odd one out where my hardware
> > is not trustworthy, but I don't know I have to take action to have it
> > checked.
>=20
> The thing is it's not just sashiko.  Various AI driven patchers seem to
> be using the prompts, which has lead to a slew of malicious hardware
> fixes being sent to linux-scsi and I'm getting a bit worn out replying
> to them saying that's not in our threat model.
>=20
> So I figured why not fix the problem at source.

I don't think anyone's saying you shouldn't (fix  the problem at the
source), as far as I'm concerned we're just debating the merits of opt-
in vs. opt-out :)

johannes
