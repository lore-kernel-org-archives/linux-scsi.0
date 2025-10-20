Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E5FF4FA;
	Mon, 20 Oct 2025 13:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760968643; cv=pass; b=u+dKKkmxoOUeN/mOZKTBrLyUprGrit53CviLQIAQY2LHHZLDIqZZ35peh2jGUQoR1a48CnkrSzHmLfau8UBWcmNW5FuMRieUfpdV4KqT5kLK4Rvgspg3rzuxP7W9F1KzzUWxucZeFY6gpFa+yjNo5MQ1AAWz2xWd16a13oOk5r0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760968643; c=relaxed/simple;
	bh=gGUyP/z5SYGHzwku0MV1Syx4oMNK9kl6KPfrS9cvVVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lsJpSYM6Zgdwgwyfi/5l83qR0tUc8I8DFEkPls6QZN+UXp9qkJI9SZvqVU2vVdd4JNMXjbELXcWN1Fq6GqkGj+wl0c9puyjLz708D90MrABE03Yy31nSoPg4gJKYLNgYt57xNlF0p1oE6NQgwWE+eY0tSI+IAWs8MfcJ30WHDDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=VzqvIjc8; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="VzqvIjc8"
ARC-Seal: i=1; a=rsa-sha256; t=1760968609; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=B76x+v2U612DJuvjGJrxH9KxhqLNSHabXgPOtil2Al6AvzEPDXhdQ3pM0+2MjuypEfl4BC/0qiZWFdw1rDob742eajmqBEAz5nQX2NrnkMxAFKnha77sbTdE8DFzzaETh0Wfvm6+m8dqsdqdMP08A60N9Ar/Q4CO1Roam4dJo9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760968609; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nqHvMgb0znCwfqJeA+RPXM5wvAfiMBWwT5rw7djWXRU=; 
	b=k6t1B/lOVxI/5dz0U9zfC9L/tgdqerNFT21Wg03c7tDDtGurzi96OguldTDhfy+cfM82/lHAe+o36L8qf+Duq/rvmXediBJOvu+jHQCmtTZmhqB6fGIQ8bENxzlZ75mmh7AQQ+URPt9AVoF6nsSU448UsvhNQEvRm8gy6aChDBw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760968609;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=nqHvMgb0znCwfqJeA+RPXM5wvAfiMBWwT5rw7djWXRU=;
	b=VzqvIjc8muGtBxUkI/DjmYeRjYa+BG6VmeXEj3KCpeo8JWlPAhe3u7uiEawigmU6
	/HNlExiXNYWxIr8mXk6VdNNpGp8QCASEc7PbXlSyaVxgZlfvhPkKEPXHm+FZmiawe2C
	hXw+pe9pxGgm1FZLAJLVOP/TiZMToqLI3H8Ny93E=
Received: by mx.zohomail.com with SMTPS id 1760968606551857.8630135881692;
	Mon, 20 Oct 2025 06:56:46 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: Conor Dooley <conor@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, kernel@collabora.com,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org
Subject:
 Re: [PATCH v2 1/5] dt-bindings: ufs: mediatek,ufs: Add mt8196-ufshci variant
Date: Mon, 20 Oct 2025 15:56:39 +0200
Message-ID: <2018479.PYKUYFuaPT@workhorse>
In-Reply-To: <10741243.nUPlyArG6x@workhorse>
References:
 <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
 <20251018-appliance-plus-361abdd09e75@spud> <10741243.nUPlyArG6x@workhorse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Monday, 20 October 2025 15:27:40 Central European Summer Time Nicolas Frattaroli wrote:
> On Saturday, 18 October 2025 23:30:17 Central European Summer Time Conor Dooley wrote:
> > On Fri, Oct 17, 2025 at 09:02:07PM +0200, Nicolas Frattaroli wrote:
> > > On Friday, 17 October 2025 17:42:10 Central European Summer Time Conor Dooley wrote:
> > > > On Thu, Oct 16, 2025 at 02:06:43PM +0200, Nicolas Frattaroli wrote:
> > > 
> > > > > +
> > > > > +  freq-table-hz: true
> > > > 
> > > > Then you add this deprecated property, which isn't mentioned in the
> > > > commit message and I don't see why a deprecated property is needed.
> > > 
> > > I'll rework it to use operating-points-v2 instead. It needs one of
> > > the two, or else on mt8196 at least, the hardware locks up.
> > > 
> > > I'll still add operating-points-v2 for all SoCs though, if that's
> > > okay with you.
> > 
> > Right. I'd accept freq-table-hz if the other devices here have been
> > using it all along, but if this is something new - then please use the
> > operating-points-v2 property. Looking at the binding example, it looks
> > like it does indeed use freq-table-hz, so that's probably justification
> > enough to keep doing so.
> 
> Turns out the only usage of freq-table-hz is in the examples I've added.
> Mainline does not at all have any nodes in the DT right now that would
> use this property.
> 
> Ergo, I think I will go for operating-points-v2. We might as well clean
> this up now instead of ossifying a deprecated property in a new binding
> for the sake of downstream compatibility (which should never be a concern)
> that I am already breaking. The added benefit is that if we ever do get
> better OPP definitions than just two clock states, then we can actually
> add the OPP bandwidth properties so implementations can make informed
> decisions.
> 

Nevermind, I see the existing binding had it in the example for 8183,
just not in the binding itself. So freq-table-hz it is.


