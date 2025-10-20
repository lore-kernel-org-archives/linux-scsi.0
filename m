Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44AA19992C;
	Mon, 20 Oct 2025 13:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760966907; cv=pass; b=fWLtTDQclnRgNFpUk1h7IxU2CmUqkdVbKK3qj8aem83iJtUPXQyRiYD9YglDjpq+IRra4NagdeQkJci7Amo3N4vhiV3OaHwRrlheRxmMppcJ7dFufHoPK8aog7Uf3z4P/HB1q3wipejJNg2kjWxFekFrQBaoK3wgFs1RLXj68Wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760966907; c=relaxed/simple;
	bh=J0R2XxBJeljrr4o1k8rc4y7oCuAm9OrS8YYT1Mhd9nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6fzaSWHpz0qeZ1eGc2Zcu8TKqBwLqLgUtk50OVIkVil/j7VDu/JfxUUtmJoJ8TRCzKQ21H09Tq8GeBPcuC9zpsfzHUrj3rlWG0FJSTuwSUpCm5EDNcCCo1xVfrYac80TFY3uBSFkHNVFiZvRlYp9N0hTOtNkvha26ugkNLcttI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=hRSoRzjw; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="hRSoRzjw"
ARC-Seal: i=1; a=rsa-sha256; t=1760966872; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=He/f49qslKpHvyW5PChKhFRZDapqS6wbjZaqcDIjq3H8VFdXEcEdCN3IZ6fjyZ1XX4Ppx+dNJZWy94mz74NvB/A7fmLv//2KHoRnImhArG+gjTlvJkJH7OBg2CeHOmPX8uAfqw3is7Lw/fvx6cwhjgC8ZJKqVbEFZ1Etp9Ia6f8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1760966872; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qPorIT6XFY77HZt0zXFnpqhwxa/ck6aI8q7AOZUlrNE=; 
	b=VrK06wVnOZghZGz5bBAGeTgC2vg+0mkYqh9khgNUlP5aUQYspnE9QZthGq7c5AYi6jZBGVmjzn9ZkATprPbngGjkNOLqN7P8tDpfh+Z8iDCymtY3obMfsYKrwYCNr2t8SEN9BaRGvPk+pyZhDHK9Gh0hfVbJt4hTxlpoak4Pevs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1760966872;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=qPorIT6XFY77HZt0zXFnpqhwxa/ck6aI8q7AOZUlrNE=;
	b=hRSoRzjwmhOtmUr5OjBlCj47NSAFZOBetLyqTnMNS4wnieeJ2kQEivSdvxoPHYtN
	Ak7iX+kjY0mfUbMb6KjnrgW5Bu91ai+mlE/xu/QAEY1IPjU3lTt8vqUq4m9rlm71JxY
	PVyVLcHZsCeyXcQeOOeJSNuLnZ+gZYyQt7Xirx4Y=
Received: by mx.zohomail.com with SMTPS id 1760966870275776.6675804138243;
	Mon, 20 Oct 2025 06:27:50 -0700 (PDT)
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
Date: Mon, 20 Oct 2025 15:27:40 +0200
Message-ID: <10741243.nUPlyArG6x@workhorse>
In-Reply-To: <20251018-appliance-plus-361abdd09e75@spud>
References:
 <20251016-mt8196-ufs-v2-0-c373834c4e7a@collabora.com>
 <118487283.nniJfEyVGO@workhorse> <20251018-appliance-plus-361abdd09e75@spud>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Saturday, 18 October 2025 23:30:17 Central European Summer Time Conor Dooley wrote:
> On Fri, Oct 17, 2025 at 09:02:07PM +0200, Nicolas Frattaroli wrote:
> > On Friday, 17 October 2025 17:42:10 Central European Summer Time Conor Dooley wrote:
> > > On Thu, Oct 16, 2025 at 02:06:43PM +0200, Nicolas Frattaroli wrote:
> > > > The MediaTek MT8196 SoC contains the same UFS host controller interface
> > > > hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
> > > > its list of allowed clocks, as well as give it the previously absent
> > > > resets property.
> > > > 
> > > > Also add examples for both MT8195 and the new MT8196, so that the
> > > > binding can be verified against examples for these two variants.
> > > > 
> > > > Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> > > > Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> > > 
> > > I provided a review on v1 of this series yesterday, although I think
> > > after this v2 was posted.
> > > https://lore.kernel.org/all/20251016-kettle-clobber-2558d9c709de@spud/
> > > I believe all of my comments still apply.
> > 
> > thanks for your review, I'll respond to the comments of those here
> > to avoid needlessly bumping the v1 thread.
> 
> Cool, good idea.
> 
> > On Thursday, 16 October 2025 18:53:01 Central European Summer Time Conor Dooley wrote:
> > > Hey,
> > > 
> > > On Tue, Oct 14, 2025 at 05:10:05PM +0200, Nicolas Frattaroli wrote:
> > > > The MediaTek MT8196 SoC contains the same UFS host controller interface
> > > > hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
> > > > its list of allowed clocks, as well as give it the previously absent
> > > > resets property.
> > > > 
> > > > Also add examples for both MT8195 and the new MT8196, so that the
> > > > binding can be verified against examples for these two variants.
> > > > 
> > > > Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> > > > ---
> > > >  .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 134 +++++++++++++++++++--
> > > >  1 file changed, 123 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > index 1dec54fb00f3..070ae0982591 100644
> > > > --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > > @@ -11,18 +11,30 @@ maintainers:
> > > >  
> > > >  properties:
> > > >    compatible:
> > > > -    enum:
> > > > -      - mediatek,mt8183-ufshci
> > > > -      - mediatek,mt8192-ufshci
> > > > -      - mediatek,mt8195-ufshci
> > > > +    oneOf:
> > > > +      - enum:
> > > > +          - mediatek,mt8183-ufshci
> > > > +          - mediatek,mt8195-ufshci
> > > > +      - items:
> > > > +          - enum:
> > > > +              - mediatek,mt8192-ufshci
> > > > +          - const: mediatek,mt8183-ufshci
> > > 
> > > It's hard to follow what's going on in this commit.
> > > Firstly, this seems to be some sort of unrelated change that isn't
> > > mentioned in the commit message.
> > 
> > Sorry about that. Basically, the binding is currently wildly
> > incomplete, and this was my attempt at making it at least partly
> > useful for mainline DTs. You'll note that currently, no complete
> > (i.e. not just SoC dtsi) device tree uses it, and if they did,
> > all would most definitely generate warnings if they used it in a way
> > that actually worked, or silently relied on incomplete descriptions
> > that just happened to work out in practice.
> > 
> > So I'm being a bit heavy-handed here at untangling things. The
> > compatible changes here are to stop pretending that the mt8195
> > can use the mt8183 as a fallback, as the binding itself would
> > not really agree with that AFAIU. The mt8183 sets the maximum
> > number of clocks to 1, whereas mt8195 sets the minimum to 8.
> 
> The binding doesn't allow the 8183 as a fallback for the 8195, so that
> tracks ;)
> 
> Really the problem is that the commit subject says that this is adding
> 8196, but that's not what the body of the commit actually is. I know you
> mention splitting further down the mail, but what I'd really like to see
> done is one commit that corrects the property situation for the 8195,
> providing whatever justifications you have for the changes - it's okay
> if you don't necessarily have explanations for backed by stuff from docs
> or whatever, if all you have is based on what platforms with the 8195 are
> doing just mention that as why you need to have x-supply or whatever.
> Then add one commit that adds the 8196, which is probably a fairly
> minimal change once the 8195 is corrected.

Alright, I think part of the confusion is me rebasing across a
midstream branch that has some unrelated bandaid fixes in it
which have never been submitted or were last submitted in 2024.
I'll simply drop those from my boot-testing branch and do my own
thing as I see fit, because things that were never submitted
upstream aren't real and can't hurt me.

> 
> > > > +      - items:
> > > > +          - enum:
> > > > +              - mediatek,mt8196-ufshci
> > > > +          - const: mediatek,mt8195-ufshci
> > > >  
> > > >    clocks:
> > > >      minItems: 1
> > > > -    maxItems: 8
> > > > +    maxItems: 16
> > > >  
> > > >    clock-names:
> > > >      minItems: 1
> > > > -    maxItems: 8
> > > > +    maxItems: 16
> > > 
> > > Then all devices grow 8 more permitted clocks, despite the wording in
> > > the commit message being 8195 specific. (Hint: you missed maxItems: 8 in
> > > the else)
> > 
> > Right, thanks, I'll add maxItems to the clock-names property in the else.
> > Though that's already missing.
> > 
> > > > +
> > > > +  freq-table-hz: true
> > > 
> > > Then you add this deprecated property, which isn't mentioned in the
> > > commit message and I don't see why a deprecated property is needed.
> > 
> > I'll rework it to use operating-points-v2 instead. It needs one of
> > the two, or else on mt8196 at least, the hardware locks up.
> > 
> > I'll still add operating-points-v2 for all SoCs though, if that's
> > okay with you.
> 
> Right. I'd accept freq-table-hz if the other devices here have been
> using it all along, but if this is something new - then please use the
> operating-points-v2 property. Looking at the binding example, it looks
> like it does indeed use freq-table-hz, so that's probably justification
> enough to keep doing so.

Turns out the only usage of freq-table-hz is in the examples I've added.
Mainline does not at all have any nodes in the DT right now that would
use this property.

Ergo, I think I will go for operating-points-v2. We might as well clean
this up now instead of ossifying a deprecated property in a new binding
for the sake of downstream compatibility (which should never be a concern)
that I am already breaking. The added benefit is that if we ever do get
better OPP definitions than just two clock states, then we can actually
add the OPP bandwidth properties so implementations can make informed
decisions.

> > > > +
> > > > +  interrupts: true
> > > >  
> > > >    phys:
> > > >      maxItems: 1
> > > > @@ -30,7 +42,15 @@ properties:
> > > >    reg:
> > > >      maxItems: 1
> > > >  
> > > > +  resets:
> > > > +    maxItems: 3
> > > > +
> > > > +  reset-names:
> > > > +    maxItems: 3
> > > 
> > > You cannot use reset-names if you don't define what the names are.
> > > Please provide a items list with descriptions in resets and some
> > > names in reset-names.
> > 
> > Will do.
> > 
> > > 
> > > >    vcc-supply: true
> > > > +  vccq-supply: true
> > > > +  vccq2-supply: true
> > > 
> > > And then two new supplies that are not mentioned in the commit message,
> > > and again are allowed for all variants. The commit message talks about
> > > extended 8195 features, so this is starting to look like there was some
> > > sort of squashing accident.
> > 
> > No squashing accident, just me trying to get around having to justify
> > things I cannot justify. I've just checked the MT8195 and MT8196
> > datasheets for their pins, and see that MT8195 has a 1.8V and two 1.2V
> > supplies.
> 
> As I said above, if you don't have some documented justification, just
> cite usage or w/e, that's better than not mentioning it at all. If you
> don't work for the vendor (and sometimes, sadly, when you do) it's not
> possible to get complete info.
> 
> > MT8196 on the other hand has seemingly no 1.8V UFS supply, but two
> > 1.2V supplies and two 0.9V supplies.
> > 
> > I think MT8195 can use vcc-supply for 1.8V (with the vcc-supply-1p8
> > flag) and vccq-supply/vccq2-supply for 1.2V.
> > 
> > I suppose MT8196 then gets two 0.9v supply properties to play with in
> > its driver, I'm open to name suqqestions. Vendor uses va09-supply, but
> > that only covers one of the two possible supplies.
> > 
> > Interestingly, MT8183 has all of 1.8V, 1.2V and 0.9V supplies as
> > well. No duplicates though.
> > 
> > MT8192 has 1.8V, and two different 1.2V supplies for UFS.
> > 
> > It's also entirely possible that some other supply rail is used
> > as well for 1.8V operation on MT8196, but I'm not privy to this
> > kind of information.
> > 
> > So yeah, I'll fix the supply situation, maybe by splitting
> > this into a few separate commits.
> 
> My personal opinion is that the best way to do supplies is to match as
> close to possible as the datasheet names for the supply. If that means
> the supply names have to be different between devices, I think the
> more complex binding is better than trying to get the names to somehow
> fit for all devices.

Alright. I think I agree with this. I've tried to use the ufs common
supply names because I thought that was the way to go, but using the
supply names that are in the datasheets seems much more clear and
reasonable to me, as we're no longer introducing different meanings
depending on the used compatible.

> 
> > > >    mediatek,ufs-disable-mcq:
> > > >      $ref: /schemas/types.yaml#/definitions/flag
> > > > @@ -44,22 +64,19 @@ required:
> > > >    - reg
> > > >    - vcc-supply
> > > >  
> > > > -unevaluatedProperties: false
> > > > -
> > > >  allOf:
> > > >    - $ref: ufs-common.yaml
> > > > -
> > > >    - if:
> > > >        properties:
> > > >          compatible:
> > > >            contains:
> > > > -            enum:
> > > > -              - mediatek,mt8195-ufshci
> > > > +            const: mediatek,mt8195-ufshci
> > > 
> > > The commit message says:
> > > | hardware as the MT8195 SoC. Add it as a variant of MT8195, and extend
> > > | its list of allowed clocks, as well as give it the previously absent
> > > | resets property.
> > > 
> > > I don't know if that's meant to mean that only the new device has 16 and
> > > the 8195 only has 8, or if the 8195 should have had 16 possible clocks
> > > too.
> > 
> > It looks like MT8195 has crypt_mux, crypt_lp, crypt_perf and ufs_rx_symbol0
> > and ufs_rx_symbol1. I haven't found any of ufs_sel/ufs_sel_min_src/
> > ufs_sel_max_src analogues yet.
> 
> I went and looked at the driver, and the list of clocks it looks up
> don't even match what the binding permits for the 8195 (or any other
> device):
> 
> 	if (ufs_mtk_init_host_clk(hba, "crypt_mux",
> 				  &cfg->clk_crypt_mux))
> 		goto disable_caps;
> 
> 	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
> 				  &cfg->clk_crypt_lp))
> 		goto disable_caps;
> 
> 	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
> 				  &cfg->clk_crypt_perf))
> 		goto disable_caps;
> 
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            enum:
> +              - mediatek,mt8195-ufshci
> +    then:
> +      properties:
> +        clocks:
> +          minItems: 8
> +        clock-names:
> +          items:
> +            - const: ufs
> +            - const: ufs_aes
> +            - const: ufs_tick
> +            - const: unipro_sysclk
> +            - const: unipro_tick
> +            - const: unipro_mp_bclk
> +            - const: ufs_tx_symbol
> +            - const: ufs_mem_sub
> 
> Looks like that series should never have actually been accepted,
> particularly given some of the commentary on it. It's worth noting, that
> there is no ack etc from a devicetree binding maintainer. Telling I
> suppose.

Yeah :(

> 
> You don't mention this mismatch in your commit message, but you should.
> 
> Also makes me wonder why the driver doesn't bother to enable all of
> these clocks either, since the IP must need them for something, right?
> Does the driver even work for 8195?

It's possible that it's relying on clock states from some magic MCU
that fiddles with things. It should definitely be fixed if that's the
case.

> 
> > Should I in this case order those three last, and then set the minimum
> > number of clocks to 13? Should I not make mt8195 a fallback for mt8196
> > at all?
> 
> For fallbacks, mostly think of it as "if the driver probed thinking that
> this was a 8195, would it work correctly"? If you have to make changes
> to a driver written for a 8195 to support clocks that are required on a
> 8196, then the devices are not compatible. If the 8196 will function if
> the extra clocks are not enabled, then sure have a fallback. But if you
> need to turn them on, then the devices are not compatible.
> In other words, if the fallback doesn't implement a viable subset of
> features on the new device, then it's not suitable.

I've just tried MT8196 with only the 13 clocks MT8195 will have once
I get to work, and it seems to probe fine an read from UFS fine.
Doesn't necessarily have to mean anything because again, a magic
MCU may be fiddling with the clock gates.

However, since the supplies of MT8195 won't be a subset of the
supplies of MT8196, I won't make it a fallback relationship.
E.g. an MT8195 device could be allowed to just have the 1.8V
supply and an MT8196 device could be allowed to just have the
1.2V/0.9V supplies, which means an implementation written against
the MT8195 binding would not work for the MT8196.

> 
> As for the 13 v 16 etc, sure order them last. You'll have to be careful
> with how you set up the conditional portion of the binding so that it
> doesn't create impossible constraints, if you decide that a fallback is
> suitable. Obviously, if there's no fallback, cos the extra 3 clocks are
> mandatory, then it'll be much easier to set the conditions up.
> 
> > > >      then:
> > > >        properties:
> > > >          clocks:
> > > >            minItems: 8
> > > >          clock-names:
> > > > +          minItems: 8
> > > >            items:
> > > >              - const: ufs
> > > >              - const: ufs_aes
> > > > @@ -69,6 +86,19 @@ allOf:
> > > >              - const: unipro_mp_bclk
> > > >              - const: ufs_tx_symbol
> > > >              - const: ufs_mem_sub
> > > > +            - const: crypt_mux
> > > > +            - const: crypt_lp
> > > > +            - const: crypt_perf
> > > > +            - const: ufs_sel
> > > > +            - const: ufs_sel_min_src
> > > > +            - const: ufs_sel_max_src
> > > > +            - const: ufs_rx_symbol0
> > > > +            - const: ufs_rx_symbol1
> > > > +        reset-names:
> > > > +          items:
> > > > +            - const: unipro_rst
> > > > +            - const: crypto_rst
> > > > +            - const: hci_rst
> > > >      else:
> > > >        properties:
> > > >          clocks:
> > > > @@ -76,6 +106,10 @@ allOf:
> > > >          clock-names:
> > > >            items:
> > > >              - const: ufs
> > > > +        resets: false
> > > > +        reset-names: false
> > > > +
> > > > +unevaluatedProperties: false
> > > >  
> > > >  examples:
> > > >    - |
> > > > @@ -99,3 +133,81 @@ examples:
> > > >              vcc-supply = <&mt_pmic_vemc_ldo_reg>;
> > > >          };
> > > >      };
> > > > +  - |
> > > > +    ufshci@11270000 {
> > > > +        compatible = "mediatek,mt8195-ufshci";
> > > > +        reg = <0x11270000 0x2300>;
> > > > +        interrupts = <GIC_SPI 137 IRQ_TYPE_LEVEL_HIGH>;
> > > > +        phys = <&ufsphy>;
> > > > +        clocks = <&infracfg_ao 63>, <&infracfg_ao 64>, <&infracfg_ao 65>,
> > > > +                 <&infracfg_ao 54>, <&infracfg_ao 55>,
> > > > +                 <&infracfg_ao 56>, <&infracfg_ao 90>,
> > > > +                 <&infracfg_ao 93>;
> > > > +        clock-names = "ufs", "ufs_aes", "ufs_tick",
> > > > +                      "unipro_sysclk", "unipro_tick",
> > > > +                      "unipro_mp_bclk", "ufs_tx_symbol",
> > > > +                      "ufs_mem_sub";
> > > > +        freq-table-hz = <0 0>, <0 0>, <0 0>,
> > > > +                        <0 0>, <0 0>, <0 0>,
> > > > +                        <0 0>, <0 0>;
> > > > +        vcc-supply = <&mt6359_vemc_1_ldo_reg>;
> > > > +        mediatek,ufs-disable-mcq;
> > > > +    };
> > > > +  - |
> > > > +    #include <dt-bindings/reset/mediatek,mt8196-resets.h>
> > > > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > > > +
> > > > +    ufshci@16810000 {
> > > > +        compatible = "mediatek,mt8196-ufshci", "mediatek,mt8195-ufshci";
> > > > +        reg = <0x16810000 0x2a00>;
> > > > +        interrupts = <GIC_SPI 320 IRQ_TYPE_LEVEL_HIGH>;
> > > > +
> > > > +        clocks = <&ufs_ao_clk 6>,
> > > > +                 <&ufs_ao_clk 7>,
> > > > +                 <&clk26m>,
> > > > +                 <&ufs_ao_clk 3>,
> > > > +                 <&clk26m>,
> > > > +                 <&ufs_ao_clk 4>,
> > > > +                 <&ufs_ao_clk 0>,
> > > > +                 <&topckgen 7>,
> > > > +                 <&topckgen 41>,
> > > > +                 <&topckgen 105>,
> > > > +                 <&topckgen 83>,
> > > > +                 <&topckgen 42>,
> > > > +                 <&topckgen 84>,
> > > > +                 <&topckgen 102>,
> > > > +                 <&ufs_ao_clk 1>,
> > > > +                 <&ufs_ao_clk 2>;
> > > > +        clock-names = "ufs",
> > > > +                      "ufs_aes",
> > > > +                      "ufs_tick",
> > > > +                      "unipro_sysclk",
> > > > +                      "unipro_tick",
> > > > +                      "unipro_mp_bclk",
> > > > +                      "ufs_tx_symbol",
> > > > +                      "ufs_mem_sub",
> > > > +                      "crypt_mux",
> > > > +                      "crypt_lp",
> > > > +                      "crypt_perf",
> > > > +                      "ufs_sel",
> > > > +                      "ufs_sel_min_src",
> > > > +                      "ufs_sel_max_src",
> > > > +                      "ufs_rx_symbol0",
> > > > +                      "ufs_rx_symbol1";
> > > > +
> > > > +        freq-table-hz = <273000000 499200000>, <0 0>, <0 0>, <0 0>, <0 0>,
> > > > +                        <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>, <0 0>,
> > > > +                        <0 0>;
> > > > +
> > > > +        phys = <&ufsphy>;
> > > > +
> > > > +        vcc-supply = <&mt6363_vemc>;
> > > > +        vccq-supply = <&mt6363_vufs12>;
> > > > +        vccq2-supply = <&mt6363_vufs18>;
> > > > +
> > > > +        resets = <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_UNIPRO>,
> > > > +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFS_CRYPTO>,
> > > > +                 <&ufs_ao_clk MT8196_UFSAO_RST1_UFSHCI>;
> > > > +        reset-names = "unipro_rst", "crypto_rst", "hci_rst";
> > > 
> > > Putting _rst in the name of a reset is redundant.
> > > 
> > > pw-bot: changes-requested
> > > 
> > > Thanks,
> > > Conor.
> > > > +        mediatek,ufs-disable-mcq;
> > > > +    };
> > > > 
> > > 
> > 
> > Thanks for the review, I'll try to get a v3 out next week that
> > addresses these issues and also makes the required adjustments
> > to the drivers.
> 
> Cool. TL;DR, just be clear about where things are coming from and please
> try to sort out the 8195 mess in a different patch to the 8196.
> 
> Cheers,
> Conor.
> 

Thank you for helping to clear this whole mess up. Turns out this
was way more work than initially expected, but I reckon if I come
in like a wrecking ball right now then that will make the job easier
for everyone contributing to mainline in the future.

Kind regards,
Nicolas Frattaroli




