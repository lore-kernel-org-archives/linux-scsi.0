Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220066;
	b=tHEuFkYV1qxMKiS/xJy9upm9asxEl+KHJz8GBiUkzGViv6F3MZ2igXHrOLcSdDrYXRLs
	 EMwtRr6YA3Naa8Od3l3XL2L8FDI6b8wZbbFVRVKxiYu7/Jw8Ri4EXeUqupNBH4QkEVtUr
	 /Y4VDhNtNoU36M3flQ6nPbd28xUXKIoTzu7Y+WV+dqrkkdlZyWman3fEurq7N9OXGpsgH
	 lP6+/uWc60Zh9/tqFG0JHiQLeRlN8ag+0Gz7h7B0xdaQNsJjcYOAikeiYakIYZ1cfOXRO
	 ruNrNIfIKMAVmlvXhxctQa0W/E5elaeY82a/a/OAUIumiTzHZcX2bd+FCYVbXobBjTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220066;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=1LISWoLx7jyoaFe432D1rgOTIlQ7ytFtj+s/0tgjA35+jf8NrWMBaVqNnVAFikhyMIdP
	 +zu3CjL3flNEXkMt0zj2pb/s/xGGMCaEwbz0N/Fkv9RPjV2vlz1VbLIyVsqn3UKbj5bMX
	 iVsggaIg++1pM87h1qnB//KbAx+gOpmNqCCyCcltcdLEcCcALJeYd7HfKfWfGK67nCU77
	 JYK88GN9haPN++lt2p6qu8eU54ThhR2nNOYIyVqU5s66QRRlnNAA9rqqK8MPJwE4pyzS2
	 Mx2RGwUzUD4akwoC9GnkHcahMKfPm/RrJ1GFkIWKuIEgEKMpoKYwwzCgxzf9UNiXQNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC81606A69C;
	Sat, 21 Nov 2026 00:14:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DC81606A69C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E9E926732A; Sat, 21 Nov 2026 01:14:21 +0100 (CET)
Date: Sat, 21 Nov 2026 01:14:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v13 08/13] zloop: add storage element emulation
Message-ID: <20261121001421.GB13058@lst.de>
References: <20261120210651.580511-1-dlemoal@kernel.org> <20261120210651.580511-9-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120210651.580511-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

