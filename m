Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="e8+8TB1l"
Received: from madrid.collaboradmins.com (madrid.collaboradmins.com [IPv6:2a00:1098:ed:100::25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE35F9C;
	Wed, 13 Dec 2023 02:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1702465197;
	bh=Qdg2Wjhg+ytGk4SRjlf7DKRMcZo2+lDhtopoNOut+bc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e8+8TB1luoal4RtgGV3wAWXp6c9OwniwUnxZ9i685dFrMLxnu+z/6iDmcB2MI2zkV
	 yvCJ62jnehXqLwwFO8X/2EPrHw4SECNdaPpeWK2yyE1MR3LWD73T/m1ZtJccOyEe6q
	 77kUZZD+hz5KZcpRJyyV90acFrYBZunOrVuFJnH5JE0590HgWgHUTpYRw4+siLctm/
	 VnuIcdDmercHY4OJlYV440wGShhjr+Sq86+0WKrkNyBYzGRfA20D5jGj8DbKDeoOfg
	 rN5BqKiRzXjqVbS3O4WBgaPbAh50UCmtlf7iJiHVtkxqYQ9oWpoHm3hfHX2DUBvbHo
	 9o5DIMIqiX2rQ==
Received: from [100.113.186.2] (cola.collaboradmins.com [195.201.22.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by madrid.collaboradmins.com (Postfix) with ESMTPSA id 509FA3781484;
	Wed, 13 Dec 2023 10:59:56 +0000 (UTC)
Message-ID: <84446493-2c3f-45b7-9d77-54a77e753d16@collabora.com>
Date: Wed, 13 Dec 2023 11:59:55 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/2] ufs: ufs-mediatek: Enable CPU latency PM QoS
 support for MEDIATEK SoC
Content-Language: en-US
To: Maramaina Naresh <quic_mnaresh@quicinc.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Matthias Brugger <matthias.bgg@gmail.com>, stanley.chu@mediatek.com
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <chu.stanley@gmail.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 quic_cang@quicinc.com, quic_nguyenb@quicinc.com
References: <20231213103642.15320-1-quic_mnaresh@quicinc.com>
 <20231213103642.15320-3-quic_mnaresh@quicinc.com>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
In-Reply-To: <20231213103642.15320-3-quic_mnaresh@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 13/12/23 11:36, Maramaina Naresh ha scritto:
> Revert the existing PM QoS feature from MEDIATEK UFS driver as similar
> PM QoS feature implementation is moved to core ufshcd.
> 
> Signed-off-by: Maramaina Naresh <quic_mnaresh@quicinc.com>

IMO, title and description should say:

ufs: ufs-mediatek: Migrate to UFSHCD generic CPU latency PM QoS support

The PM QoS feature found in the MediaTek UFS driver was moved to the UFSHCD
core: remove it from here as it's now redundant.

with that fixed:

Reviewed-By: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

