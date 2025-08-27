Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45C275872
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 05:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756274170; cv=none; b=LCl0x7GH5xcYzvZ1G26QSDpDoCB86A4GoJQeRJpWf4OMhiBsYJ2ZUEXeEAGwI5eX1VwDsSrbR7kct/XZEx6AyIrr4NyDYn45WUOxg8G3BbMahSI1iUWMyoO4DmapNgz75bTGBjlEtLwFdJO+JYzV/HdvIsljPgZvAxsHp8lYIoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756274170; c=relaxed/simple;
	bh=BbD6VwYuebZvVXUTjVIB736OOnh+InOqS07iPo4EGII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jxyHwqyNFgAuT74zGIKZVHlvRGJ3N3Nu6DGjANbW87W/AYpHbB+Mj9Ue332/eT+vB4xrMEvZ7EJ/rXyG8AmwAbk08JiT39SxuGgdczxA5IbBIenQIzm6jDveKwrvIvLQATvS4cAPMq+C1NifPiJ1Ce3BfwhHYFeAGjCcQWoUhzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=QUIln5s2; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="QUIln5s2"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id r4CyunqgJpJsQr979uq6sp; Wed, 27 Aug 2025 05:54:31 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id r978ubFiCOhG0r978uJQnd; Wed, 27 Aug 2025 05:54:30 +0000
X-Authority-Analysis: v=2.4 cv=PIgP+eqC c=1 sm=1 tr=0 ts=68ae9d96
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=DR2cKC/DEnBA9KqqjaPhpA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7T7KSl7uo7wA:10
 a=2AWf5FwvJw1iBHfDe3AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WDJGNaVGxwh+yCobnWlXXZbYF5Bu0xJlzbT0v72eZ/Y=; b=QUIln5s2eYN8GScnE9vXjS9uSf
	tPmySM2JLcYvGA1m1XKq4aEnX/inUyKvpfB4CRSks+IPqNQT5/8y64YARHQQJ/lyaaG4c3/dxtZf1
	HDnxbGMM2IajLtU1x77StimGO292yCeD2SVnhjqnuVJCnp9u3f9+29e/FT902XqZGKQoEGMhiehMn
	fRedJQmbDm4nQOpHGnmg02VK5w83GlKyhqGD1cc81iZ5/59a7YP95O527Q6ItF3u4RrhqZc50fL1L
	cjLz+ZP2ce3zSKOkgaeFbBJwM3IrycAIaiUyqW9zqb6Xjkv0bg1Mu4UGV5WUetdlBCMa1WyAj877O
	ip9H/dKQ==;
Received: from static-243-216-117-93.thenetworkfactory.nl ([93.117.216.243]:42968 helo=[10.94.27.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1ur977-00000003S0N-1GL6;
	Wed, 27 Aug 2025 00:54:30 -0500
Message-ID: <c3988bb4-a51e-4d7e-90d6-7c37020cd1b4@embeddedor.com>
Date: Wed, 27 Aug 2025 07:54:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] scsi: fc: Avoid -Wflex-array-member-not-at-end
 warnings
To: Justin Tee <justintee8345@gmail.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: James Smart <james.smart@broadcom.com>,
 Justin Tee <justin.tee@broadcom.com>, Hannes Reinecke <hare@suse.de>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aJtMETERd-geyP1q@kspp> <yq1seheonya.fsf@ca-mkp.ca.oracle.com>
 <CABPRKS9BVsGhBDmNVbts9QhMsJ-mZhMKDB4u-NnfVcVLsfWrAg@mail.gmail.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <CABPRKS9BVsGhBDmNVbts9QhMsJ-mZhMKDB4u-NnfVcVLsfWrAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 93.117.216.243
X-Source-L: No
X-Exim-ID: 1ur977-00000003S0N-1GL6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: static-243-216-117-93.thenetworkfactory.nl ([10.94.27.44]) [93.117.216.243]:42968
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAIZnZontIofsDRn8n53i1fzV/ZEjQdw6o029oshA19nWlRzuvpBXetGtNjhUh26CPll2yJwrVeGrwVCBzwcoIWvjm20wwN1W6GZhvjRBteu4ejROcqu
 my438hW8hLu3EwjntRgvGe7yP/0Zm0AZ+JKu+nZmCFVFh6cOJhNYjWphXecoH2QOKmAnREFWyzBIe84M69T1Bc6cNfSLHKwDZhMyPjvzfBL9rHBG4qIKb2Ev



On 27/08/25 01:13, Justin Tee wrote:
> Hi Martin and Gustavo,
> 
> Regarding the maintainers file, yes Broadcom will push a patch to update soon.
> 
> Regarding Gustavo’s patch, I think we should also update the
> assignment of rdf.desc_len in lpfc_els.c like below.
> 
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index fca81e0c7c2e..432761fb49de 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -3762,7 +3762,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport,
> uint8_t retry)
>          memset(prdf, 0, cmdsize);
>          prdf->rdf.fpin_cmd = ELS_RDF;
>          prdf->rdf.desc_len = cpu_to_be32(sizeof(struct lpfc_els_rdf_req) -
> -                                        sizeof(struct fc_els_rdf));
> +                                        sizeof(struct fc_els_rdf_hdr));

Good catch! :)

Thanks
-Gustavo

