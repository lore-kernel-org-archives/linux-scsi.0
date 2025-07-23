Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C5C277CBC;
	Wed, 23 Jul 2025 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753258208; cv=none; b=NMZ0u8uDiINMNKN9hXzrrkqGFgoPezstq3V3RN7CK4QqJ6qvtItFViVYOLcwN4T96kWA3HSoqwMRm5MgPhZaLj3HQkaS/mgceSrMVmiqdPGWfeLINcCePbH4aGzMiT4DtwJ0lXis74I1NJAFGlv3KfANrmx+cBmH6dwCQ3ylMxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753258208; c=relaxed/simple;
	bh=EdhV/HoC6xZnX2bnuCV2/LzTZIEfyRdVxGCTzPm+bK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stEv0D9vsEM8lidEOdvto1cLL9Lhrr9E4eXzEvoteJXEGnpc7PUH7GDt8E9Y0cgx+60EgABplD0vvCfGGNclbMb3MD9vRtzw7euZQn27ovs+7Iwu+NWHyposg1Xx8oCACcpzjScG2J4nxByxKTfi4GprrxMVtaNl5GAp5H/VvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=BL+gnleZ; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="BL+gnleZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1753258204;
	bh=EdhV/HoC6xZnX2bnuCV2/LzTZIEfyRdVxGCTzPm+bK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BL+gnleZ794iAZx7tLA6dt0FfFB0Q2Rry3uLk1sG7yLLhffct61DNXSoRs1cQgUZK
	 4Qw3EgNGeV0zUItANc/V4ytSOX65TwPojnYtzpZunG6rteQWx5buVSEEeiKupwvrKE
	 0l155W/3aZOxY0DNpNIJVfO5F90N/pKQu2lirmfNXgOXOgzhNSTLBOyhDVpDRq+emY
	 kgvq6bQa99iUXtmlgGB3aKpR9FkSVhXIqnieSa2Lcx1EsNcUppCYv4Je87Doa3n9hB
	 /phYF0vawpq5rbJtDl8LGOadDEkNX5CD8KGZpUpc3eCq37VmXIbWGl+8hLvOV+teW4
	 N3FxYLUOoiP6w==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E48DD17E0CE6;
	Wed, 23 Jul 2025 10:10:02 +0200 (CEST)
Message-ID: <f1589156-7e4a-4f47-88a1-8c51f6594366@collabora.com>
Date: Wed, 23 Jul 2025 10:10:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] dt-bindings: ufs: mediatek,ufs: add MT8195
 compatible and update clock nodes
To: =?UTF-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= <Macpaul.Lin@mediatek.com>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "macpaul@gmail.com" <macpaul@gmail.com>,
 =?UTF-8?B?UGFibG8gU3VuICjlravmr5Pnv5Qp?= <pablo.sun@mediatek.com>,
 Project_Global_Chrome_Upstream_Group
 <Project_Global_Chrome_Upstream_Group@mediatek.com>,
 =?UTF-8?B?QmVhciBXYW5nICjokKnljp/mg5/lvrcp?= <bear.wang@mediatek.com>,
 =?UTF-8?B?UmFtYXggTG8gKOe+heaYjumBoCk=?= <Ramax.Lo@mediatek.com>
References: <20250722085721.2062657-1-macpaul.lin@mediatek.com>
 <20250722085721.2062657-3-macpaul.lin@mediatek.com>
 <b90956e8-adf9-4411-b6f9-9212fcd14b59@collabora.com>
 <845f204b2b2e39b794cdb9c0f3293dc8cba7286a.camel@mediatek.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <845f204b2b2e39b794cdb9c0f3293dc8cba7286a.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Il 23/07/25 09:33, Macpaul Lin (林智斌) ha scritto:
> On Tue, 2025-07-22 at 11:39 +0200, AngeloGioacchino Del Regno wrote:
>>
>> External email : Please do not click links or open attachments until
>> you have verified the sender or the content.
>>
> 
> [snip...]
> 
>> The unipro mp_bclk really is the ufs-sap clock; besides, the standard
>> has clocks
>> for both TX and RX symbols - and also MT8195 (and also MT6991,
>> MT8196, and others)
>> UFS controller do have both TX and RX symbol clocks.
>>
>> Besides, you're also missing the crypto clocks for UFS, which brings
>> the count to
>> 12 total clocks for MT8195.
>>
>> Please, look at my old submission, which actually fixes the
>> compatibles other than
>> adding the right clocks for all UFS controllers in MediaTek
>> platforms.
>>
>> https://lore.kernel.org/all/20240612074309.50278-1-angelogioacchino.delregno@collabora.com/
>>
>> I want to take the occasion to remind everyone that my fixes were
>> discarded because
>> the MediaTek UFS driver maintainer wants to keep the low quality of
>> the driver in
>> favor of easier downstream porting - which is *not* in any way
>> adhering to quality
>> standards that the Linux community deserves.
>>
> 
> Oops, it is sad to hear that.
> MediaTek will raise an internal discussion and hope
> we could get the more specific requirements back to you soon.
> 

Thanks for that.

Cheers,
Angelo
