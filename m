Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192B945C715;
	Mon, 14 Sep 2026 12:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387447; cv=none; b=JDNIBFlW2sr1vcpUr+38ja/bjnb4GEy+8AluD/s/PHIyIhToVEdWeBvv9vI6tz1GnYiGVpoSnfT1GynI4gNk0u7WBS4FxZHYD7q6t4HI3zQgCdWT8zns+5EdvSJP5zy/3plX7RiiVbUx4trFfJo92HEpruuovHM/lwJlVjyO3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387447; c=relaxed/simple;
	bh=FIBAsyGFPvfETpyBr09HjNxH1AY/V6dy8oQmWy+oGKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJlGcppXPKQ9Cw4cXavqw5CT4tUEhHzjaIXaNmcYR9I1+WFbK5O0/uagxNaqjjaPbAy9wyMgZaXoa+66ce+W3ERWMQV6rFdgDwo3m3B0umJD/yfa2p8Cx7NxWkm+Q1AGgk+7yWS7ZlZq2IeecNrRFWTu0zIAro/NL+LrN/L4csk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=LJMRJl+p; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="LJMRJl+p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1789387442;
	bh=FIBAsyGFPvfETpyBr09HjNxH1AY/V6dy8oQmWy+oGKQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LJMRJl+pUKWfH3GPfyZgm75Fi0YlKga5UpcvvrqMf4QWJ4gh29GLdVho1OI5g6X4v
	 QFTnQy3htoeUqMhV8qjZ1UW7pegE2uAT+XlSkDRzeMT+jvtV/LyEk9f9gy2I8UTa2Q
	 KiuHqW+kQE5IqDJqTC1ZaAJ/6sKUzxaN8JolzkKzXxFsI8SmC8bE9wECXcgzmDYxEu
	 0zR7+DHT+Ti33kDASsuNHrBqxNOv929m+df+QNmZpig5pmecpbpKRHbg97jmb/hsEo
	 sOVsIbeAVJ3WQ+9HNtK8NkqZKxj7+lkk0lq+1r9Aofh6nqBW76fJ+cFC0n00xYvc6A
	 rqgbBU/9wCEzg==
Received: from [100.64.1.21] (unknown [100.64.1.21])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange x25519)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8603417E020C;
	Mon, 14 Sep 2026 14:04:01 +0200 (CEST)
Message-ID: <37b8b39d-0880-4625-a8cc-f41a6aab3308@collabora.com>
Date: Mon, 14 Sep 2026 14:04:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/24] dt-bindings: ufs: mediatek,ufs: Complete the
 binding
To: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>,
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Chaotian Jing <chaotian.jing@mediatek.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>,
 Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>,
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-2-9279d7ef814d@collabora.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260914-mt8196-ufs-v12-2-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/14/26 13:38, Louis-Alexis Eyraud wrote:
> From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> 
> As it stands, the mediatek,ufs.yaml binding is startlingly incomplete.
> Its one example, which is the only real "user" of this binding in
> mainline, uses the deprecated freq-table-hz property.
> 
> The resets, of which there are three optional ones, are completely
> absent.
> 
> The clock description for MT8195 is incomplete, as is the one for
> MT8192. It's not known if the one clock binding for MT8183 is even
> correct, but I do not have access to the necessary code and
> documentation to find this out myself.
> 
> The power supply situation is not much better; the binding describes one
> required power supply, but it's the UFS card supply, not any of the
> supplies feeding the controller silicon.
> 
> No second example is present in the binding, making verification
> difficult.
> 
> Disallow freq-table-hz and move to operating-points-v2. It's fine to
> break compatibility here, as the binding is currently unused and would
> be impossible to correctly use in its current state.
> 
> Add the three resets and the corresponding reset-names property. These
> resets appear to be optional, i.e. not required for the functioning of
> the device.
> 
> Move the list of clock names out of the if condition, and expand it for
> the confirmed clocks I could find by cross-referencing several clock
> drivers. For MT8195, increase the minimum number of clocks to include
> the rx_symbol ones, as they're internal to the SoC and should always
> be present, and should therefore not be omitted.
> 
> MT8192 gets to have at least 3 clocks, as these were the ones I could
> quickly confirm from a glance at various trees. I can't say this was an
> exhaustive search though, but it's better than the current situation.
> 
> Properly document all supplies, with which pin name on the SoCs they
> supply. Complete the example with them.
> 
> Also add a MT8195 example to the binding, using supply labels that I am
> pretty sure would be the right ones for e.g. the Radxa NIO 12L.
> 
> Finally, remove the 'ufs_' prefix from all clock names containing it
> and rename 'ufs' clock to 'main'.
> 
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
> Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

