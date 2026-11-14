Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794679345;
	b=w3IpL9OLE2ZP5G7XsnR5Nip6Yz9NDCqlgRr+B57RVTBYJgx5Yv6otQv8ygdcibVtlgsY
	 7G8vmiulfpcfz2M26GoO8zogdNIkb+M7BTV4zax1D2UuAAqG/oV9Qyqib9S5MSPmoViZA
	 whnOIH8K0HnOL0byq0WO+2nLjQ/oe2j21s71KeJp/6q7knY5Hp1Z8xqaP94GWIGcRyl0q
	 3G9yTbFRHXhA2dD6gKO6TVQ/uTwxI5CgMz5nabm/YglnD4LR8W1WCxDpk1rxuCQ+s8LMB
	 2gTePvru4RsLy59rK6spgvgO+cc77vPFKatTOb+mweWVne7NqOg8G70I7eea3EptYpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794679345;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PJNfcwrmAFaUkaLd1UPZ4/LzkLaozmIFNhW+jQqUEGE=;
	b=5qJOKuGL9BhRqSAH/TmZvIHE27ZJJm2AVxupt1J5iw9JEp8Qo4zvXIw+F+9pg4UYHasE
	 xFRoOB8d0Dy9bzvBWXGmdq3+0EmX2aw8lF+OEKsNKWiwudkgtDGhnl221eeqHqgJXr74w
	 +1F0dEFQRz/+2TYX30yZIkZ842SlXK3WoDeM0NNrlSs6xQNprAh4d9yOqjANbBVeqXl8n
	 zeQe36ji9L54XbuIUAC2YaVkaXm7IwhrOGUoI06Tky4/DMTLF3S+SGWFqlvJTelCdK5/W
	 8xs2ZJdjwbyYgp+G1I44cMIfmNN1gQcJh8qZzh9WIGbK5N9TM5jFMQPLaQIcATGFKMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqN2USbo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C966606A327;
	Sat, 14 Nov 2026 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqN2USbo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF93C1F000C4;
	Sat, 14 Nov 2026 18:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794679344;
	bh=PJNfcwrmAFaUkaLd1UPZ4/LzkLaozmIFNhW+jQqUEGE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dqN2USboTzOzrNRYfuknBDbIGM+WednylywbFoxzO+rydYId6eNepPZMnLMljFcpR
	 wqjXPG17jtHMep2fDXZicEbi2PTd3N48I1T0VTZbeGmnlXXMfBYNg0SElL9MFRhPOL
	 YvkDFszNDfz2FvAFcYh68KKbCkNnam7sWhLKhBONb0g4LzxraizJ8GBLCAjlJzg3WR
	 8WHVRH5yXWckSDUqRu5HmTOT0/5xABq/intI/8hU+nAEpzn7VMl7oMathspL55vMuv
	 3HaeCliXXbmZFZNz0/sdWLJBbelyfuCNV1ZH0O6G09BGqsWW02uKMTjWAnghHZrGEf
	 XEXZgb76kPnog==
Date: Sat, 14 Nov 2026 19:02:21 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Larisa Grigore <larisa.grigore@oss.nxp.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Rob Herring <robh@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	devicetree@vger.kernel.org, Ajay Neeli <ajay.neeli@amd.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, linux-arm-msm@vger.kernel.org, 
	Peter Wang <peter.wang@mediatek.com>, linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, linux-arm-kernel@lists.infradead.org, 
	Stanley Jhu <stanleyjhu@google.com>, Frank Li <Frank.Li@nxp.com>, imx@lists.linux.dev, 
	linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>, 
	linux-mediatek@lists.infradead.org, linux-samsung-soc@vger.kernel.org, 
	Pedro Sousa <pedrom.sousa@synopsys.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, eballetb@redhat.com, 
	Peter Griffin <peter.griffin@linaro.org>, echanude@redhat.com, Chaotian Jing <chaotian.jing@mediatek.com>, 
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>, Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, linux-rockchip@lists.infradead.org, clizzi@redhat.com, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Heiko Stuebner <heiko@sntech.de>, 
	Matthias Brugger <matthias.bgg@gmail.com>, Chunyan Zhang <zhang.lyra@gmail.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Orson Zhai <orsonzhai@gmail.com>, aruizrui@redhat.com, 
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v11 12/14] dt-bindings: ufs: Add NXP S32N79 UFS host
 controller
Message-ID: <20261114-bouncy-emotional-mushroom-fcaf2e@quoll>
References: <20261114-b4-ufs-s32n7-v11-0-dc36e11919d5@oss.nxp.com>
 <20261114-b4-ufs-s32n7-v11-12-dc36e11919d5@oss.nxp.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261114-b4-ufs-s32n7-v11-12-dc36e11919d5@oss.nxp.com>

On Sat, Nov 14, 2026 at 12:55:44PM +0100, Larisa Grigore wrote:
> +  clock-names:
> +    items:
> +      - const: core
> +
> +  lanes-per-direction:
> +    const: 2

Drop, this is implied by the compatible.

This makes sense only if UFS device is on the board thus the actual
lanes differ for one SoC.

Best regards,
Krzysztof

