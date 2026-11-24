Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795535384;
	b=LSiUcsf6C6dhUjuuygQHs6j/1adjgbF+WlQOa00aWptVvuTOTItgK8mquHNCDQuFEN+H
	 grTC1gZGULLDZoUL+bp5xKVreZ4REYID8S3KEw5VdU25Eucijp2S3f6JJHjAYfCfeSH0V
	 mjR9nQAqogs/3VgTCVtMVw5BO90lixldKEoauZs4AmGxMGCSe26z4Ui2LovcR7iPu/JXq
	 HJraaTp8UCrKHa628oRB/soijhb5UR8JTY3fvoGu4DpoeXdPZN/+EfaF34oqlbOJHhR8E
	 FUMHB3hWf4dIQucORHP8B7wyG+ypU4FYvNkqJwSg2Q30+HTV+ffZaWqZIsBT7i6OsyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795535384;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=UGxZhaZ7PT1e0vo8H3m3FDdAxeIPfBUibwtB6xWqvt0=;
	b=CDOuCxOXsvTw/CwiyU3wz08RKPuYih18Niv5p6PVvthZQvcJ7l86Y1u8Oo1tuwFADMsW
	 sICHtvjIXLNM0yoJg0jatYUqSQT7v4yLBLpjD5GpB3qlJvF4t2MkDhaY+fBZZiKXxo0+Y
	 dYh0iKfF7Pq8nueRDowfxi6MmO7/1s21iFgzc/6dgTu7SOeD4aJDNwjC1JGKc+HQ0zVXE
	 S2nxQtXbV6XOcVpHQQ0X1ut6LPbq2kwCXNr2yR4+R5gsq2rIu4mpkSMN+f5Z+wU/+LhEc
	 cBBCO6pHb6oO7BNpkmC+pFn/Hx7JMB4Qzi7bNv4VqrkeJg8UYgPQHaboLignIj+8Y6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+CnhQkP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01471606A31E;
	Tue, 24 Nov 2026 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N+CnhQkP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16DE1F000D0;
	Tue, 24 Nov 2026 15:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795535383;
	bh=UGxZhaZ7PT1e0vo8H3m3FDdAxeIPfBUibwtB6xWqvt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=N+CnhQkPSmr5GtRdngXDWQ1raHQonGxOcpYVZIZAhUsDi/IgfVBNfNOpDhCUBHX4l
	 1PuBrpT3bQ+bLsO1BFBZd3GcA8y/v4AFWen4eDhhFj0Peqkbto5E0OCc5I3sA33B3l
	 YSXwnfG90MC663CTbrb3svkMMY8HcVe+Eh/FLYgzKCjcyIOjvIyQB7m094twOhW3qe
	 /1PQmckdFKy3etg0nxS1/7bGkZeiNHG4RNw8HlNEzUyrQ13Hnl3cHd2+wzLwXN9I5o
	 Qeg1XXjDL3XOAiI2MhaVkgpY6NzSX9wNOFZaRzxPPMitMBuF8qUKQTQv1vezva4KuN
	 zXAjqbrbkIPjQ==
Message-ID: <7401e343-71f9-476c-9143-26d068c28aa7@kernel.org>
Date: Tue, 24 Nov 2026 16:49:37 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: dt-bindings: Add compatible for Seca UFS Host
 Controller
To: Yadu M G <yadu.mg@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>,
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org
References: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <61136dcb5cde2c0cfe1b8f3a488e9edcf36043cf.1795517687.git.yadu.mg@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/11/2026 11:54, Yadu M G wrote:
> Seca's platform firmware implements an SCMI server that manages UFS
> resources such as the PHY, clocks, regulators and resets via the SCMI
> power protocol, like SA8255P. As a result, the OS-visible DT only
> describes the controller's MMIO, interrupt, IOMMU and power-domain
> interfaces, making SA8255P the appropriate fallback compatible.
> 
> Signed-off-by: Yadu M G <yadu.mg@oss.qualcomm.com>
> ---
> The Seca SoC device tree using this compatible will be posted as a
> separate series.
> 
> This series was prepared with help from an AI coding assistant
> (Claude). It assisted with review on the device tree, bindings and

Claude would do it right, unless you use some poor model.

As explained on the mailing lists and on maintainer summit (and
internally): if you use poor agent, you are slopping and we can throw
your patches to /dev/null.

> driver (formatting and alignment fixes), rewording commit messages,
> and running the validation steps (checkpatch, dt_binding_check,
> dtbs_check and W=1 builds). All changes were reviewed and tested on the
> Seca Ride board.
> ---
>  Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> index 66d73e9025d6..4a5dbc780b0d 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> @@ -16,6 +16,9 @@ properties:
>        - items:
>            - const: qcom,sa8797p-ufshc
>            - const: qcom,sa8255p-ufshc
> +      - items:
> +          - const: qcom,secaau-ufshc
> +          - const: qcom,sa8255p-ufshc

And Claude did not tell you how this is organized? That's one enum.

Best regards,
Krzysztof
