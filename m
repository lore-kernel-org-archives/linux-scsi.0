Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728455;
	b=XYl6OFzjebsrOMiJTu4FaQ0ozLBfDyZg3Lj4jfGXj96WENL/KtsdfmutCe/qI8dDOa67
	 7AcontK3xeeZIbTroEGtAO82h6rr+ZhkEs7pCI4d0/AOyq/YzbFr1jSkC91DK0ByqtA6w
	 /o3yh2OZkalgnvxiBWK/WTsk8DG+OnVFMxXmWs78PYDMxzORrd7hKryaKn/pAotKmZoLp
	 s7qMG53dblz1m8eRmjtmmmk4AXcD13/dK05xvbrHGDEFDyt0Gkv1kch2sQU+P3HTfixlG
	 +mZyvdVMWbxCApQTw4iSEwy1Gpnx7HIqfTmsyHkMDO6CvJKjAVdnwMVJojqLtoukdSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728455;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=XdfzJkGWADls7GIG36It0yxUfW1LFlYm3MYyInKxsiU=;
	b=ztK7JTvMynjeTAb4VcXRLINpG5wVjdohRP+AAHAtFNaoGRNzKnW6U0qD95P7svXPMz7F
	 1dyaeHgsEtDIqxPUE+0pYVHLZh8ZgpTag/yK0TR2woGCZHm8zPYbEFQGvRBN8FS42cXPt
	 L6xMKewmxeG3BEVriCsmCMlmZGrSO/Rg/8KKr4lSSkyXQtSwGIDAFw3YOFdsJaTbvvb4O
	 aPzjKD9nSZcf0adzmoYIliByYaVMXpuJghRZYNDJbPs5MtMWLp7H5iFXjdH7c7djoM77C
	 +EQv53nl9pcFuuhrW2JQtrGMAfqa7syGp8CdcLCKsgjmeEcKvLK/vT0kKT48weELORg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZBdoDk6Y;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB59606A32C;
	Tue,  3 Nov 2026 17:54:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DB59606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=ZBdoDk6Y
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jJx5y1Hl9z1XLktx;
	Tue,  3 Nov 2026 17:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793728449; x=1796320450; bh=XdfzJkGWADls7GIG36It0yxU
	fW1LFlYm3MYyInKxsiU=; b=ZBdoDk6YgmKU+GMIkskG9EI89cS48XnTb9iTkMCW
	VIOjU0DETcQwY9AtpBIXh28yGaFl6kUA9mEjvouzGZtUQCzKFkRifaJjzcMIVn9m
	bGkx8meI9grbiCktu8e9VWU/b2Yl4VuQc1sF+D/zmVuBcf+dTjlNSxKuoNkr7zhx
	dnIhpSzcAwfd9G8Jggrm2GS7jNRmZk2FVtRjNzWOPpWaGSYIXeRVjkdOrWe1uWiD
	5e0HGxQcZLerx8y9YUi/lDcIflQODs+N0ecMvMNsNJvwu0Awoki5i66jk7lEKrg+
	lJKDbtJkNM0cHvR8mTxZN3paDLNV0vh62Oc4rKAr5++3aw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cxmg-ULgACGk; Tue,  3 Nov 2026 17:54:09 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:b098:ee7:dc7c:db4e] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jJx5r4fS3z1XLkvj;
	Tue,  3 Nov 2026 17:54:08 +0000 (UTC)
Message-ID: <6c48993e-aa82-44df-a0b6-3e713c4e9ad6@acm.org>
Date: Tue, 3 Nov 2026 09:54:08 -0800
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
Subject: Re: [PATCH v10 03/11] ufs: unipro: Move Tx/Rx FSM state definitions
 to unipro.h
To: Larisa Grigore <larisa.grigore@oss.nxp.com>,
 NXP S32 Linux Team <s32@nxp.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
 Ajay Neeli <ajay.neeli@amd.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>
Cc: imx@lists.linux.dev, linux-scsi@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, clizzi@redhat.com, aruizrui@redhat.com,
 eballetb@redhat.com, echanude@redhat.com, Frank Li <Frank.Li@nxp.com>
References: <20261103133215.1385823-1-larisa.grigore@oss.nxp.com>
 <20261103133215.1385823-4-larisa.grigore@oss.nxp.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261103133215.1385823-4-larisa.grigore@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/3/26 5:32 AM, Larisa Grigore wrote:
> Move the Tx/Rx FSM state definitions from ufshcd-dwc.h to
> include/ufs/unipro.h.
> 
> These state values are UniPro/M-PHY related and are not specific to
> the DesignWare UFS host controller implementation, so unipro.h is a
> more appropriate location for sharing them.
> 
> As part of this move, drop the driver-private TX_FSM_HIBERN8 define in
> ufs-hisi and ufs-qcom and repoint their Hibern8 checks at the shared
> UFS_TX_STATE_HIBERN8 enum constant. This is a no-op change.
> 
> Since the definitions become visible to every user of the shared
> header, prefix the enum constants with UFS_ (e.g. RX_STATE_HIBERN8
> becomes UFS_RX_STATE_HIBERN8) to avoid polluting the global namespace,
> and update the existing AMD Versal2 users accordingly.
> 
> This also prepares for using these definitions in a subsequent commit.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

