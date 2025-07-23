Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB85464E;
	Wed, 23 Jul 2025 04:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753246211; cv=none; b=VDu2NzBWCttdygKbRyA6M9JAyoWVGCptv+w/4XjeJ2X/75DCn3vZhHpZ0yA4aOuSjIXemrbDdLbg6nEqkrnUyoEh06cHP4Waf3A40Uv4dygKIbF43I9+2ATdQ0MGhWzlGmZyJpWDUkA5HpjeXO40I3UtDJw4bJ3TaThewEixAww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753246211; c=relaxed/simple;
	bh=FRrcCCQQ4F/hJI3vXYnGQ/KyERQSqfeqQbk3YFvCDTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyMesLnMIYpCSTzkkSSfYnq6/H89XfGi+tcfobhYG5cLZzCgYFOweu7610iyPZUjkSWxNqKRxws2Z6CvrN2BLX5OzntES7bEa/jg/eS9V4XI1VwlTWe2Wf7cesnOkbUdW0x94dDUct5CIvbuQWR3Drpk2upQtXX6wb7caoEv3Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3cMUCxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3cMUCxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5CEC4CEE7;
	Wed, 23 Jul 2025 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753246210;
	bh=FRrcCCQQ4F/hJI3vXYnGQ/KyERQSqfeqQbk3YFvCDTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3cMUCxTLqzOQsWUObwmsbY2S/+091JqNYSeqdU0N/cOAtyVxdEmILr/RzkJdUnSl
	 jb6gz+T51o/8zfFtk8GYNes4Ts0EHdyPETGXI0bFgyPbFZCuwSBMMZZ7/ibVIbLCun
	 dcmBsj4jFXfbtdgBUhWu4B3pbbfFgS41JQZP8jRbGdXpuOqDsB8ON0qUmPiln5sVMw
	 nfxEePuVh48sExCgQLvZ72J3jJBFLpXd4QkiJDvzFA4EBWDJGN3bzfQn//zlF7HVof
	 MVpo5AsJn9fWRlbKJuIVhCTwuBscdHITGU90uxyDVzQe0o9gVoZDYvRqkrHL6s8Mnp
	 GXAI0WxPGCzSw==
Date: Tue, 22 Jul 2025 23:50:09 -0500
From: Rob Herring <robh@kernel.org>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Bear Wang <bear.wang@mediatek.com>,
	Pablo Sun <pablo.sun@mediatek.com>,
	Ramax Lo <ramax.lo@mediatek.com>, Macpaul Lin <macpaul@gmail.com>,
	MediaTek Chromebook Upstream <Project_Global_Chrome_Upstream_Group@mediatek.com>
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
Message-ID: <20250723045009.GA1218051-robh@kernel.org>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>

On Tue, Jul 22, 2025 at 11:39:54AM +0200, AngeloGioacchino Del Regno wrote:
> Il 22/07/25 10:57, Macpaul Lin ha scritto:
> > Add MT8195 UFSHCI compatible string.
> > Relax the schema to allow between one to eight clocks/clock-names
> > entries for all MediaTek UFS nodes. Legacy platforms may only need
> > a few clocks, whereas newer devices such as the MT8195 require
> > additional clock-gating domains. For MT8195 specifically, enforce
> > exactly eight clocks and clock-names entries to satisfy its hardware
> > requirements.
> > 
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> > ---
> >   .../devicetree/bindings/ufs/mediatek,ufs.yaml | 42 ++++++++++++++++---
> >   1 file changed, 36 insertions(+), 6 deletions(-)
> > 
> > Changes for v2:
> >   - Remove duplicate minItems and maxItems as suggested in the review.
> >   - Add a description of how the MT8195 hardware differs from earlier
> >     platforms.
> > 
> > diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > index 20f341d25ebc..1dec54fb00f3 100644
> > --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > @@ -9,21 +9,20 @@ title: Mediatek Universal Flash Storage (UFS) Controller
> >   maintainers:
> >     - Stanley Chu <stanley.chu@mediatek.com>
> > -allOf:
> > -  - $ref: ufs-common.yaml
> > -
> >   properties:
> >     compatible:
> >       enum:
> >         - mediatek,mt8183-ufshci
> >         - mediatek,mt8192-ufshci
> > +      - mediatek,mt8195-ufshci
> >     clocks:
> > -    maxItems: 1
> > +    minItems: 1
> > +    maxItems: 8
> >     clock-names:
> > -    items:
> > -      - const: ufs
> > +    minItems: 1
> > +    maxItems: 8
> >     phys:
> >       maxItems: 1
> > @@ -47,6 +46,37 @@ required:
> >   unevaluatedProperties: false
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            enum:
> > +              - mediatek,mt8195-ufshci
> > +    then:
> > +      properties:
> > +        clocks:
> > +          minItems: 8
> > +        clock-names:
> > +          items:
> > +            - const: ufs
> > +            - const: ufs_aes
> > +            - const: ufs_tick
> > +            - const: unipro_sysclk
> > +            - const: unipro_tick
> > +            - const: unipro_mp_bclk
> 
> The unipro mp_bclk really is the ufs-sap clock; besides, the standard has clocks
> for both TX and RX symbols - and also MT8195 (and also MT6991, MT8196, and others)
> UFS controller do have both TX and RX symbol clocks.
> 
> Besides, you're also missing the crypto clocks for UFS, which brings the count to
> 12 total clocks for MT8195.
> 
> Please, look at my old submission, which actually fixes the compatibles other than
> adding the right clocks for all UFS controllers in MediaTek platforms.
> 
> https://lore.kernel.org/all/20240612074309.50278-1-angelogioacchino.delregno@collabora.com/
> 
> I want to take the occasion to remind everyone that my fixes were discarded because
> the MediaTek UFS driver maintainer wants to keep the low quality of the driver in
> favor of easier downstream porting - which is *not* in any way adhering to quality
> standards that the Linux community deserves.

Sounds like we need a new maintainer then. They clearly don't understand 
that downstream doesn't exist.

Rob
