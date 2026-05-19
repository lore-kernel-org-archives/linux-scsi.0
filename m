Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955303B895A
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 07:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175499; cv=none; b=Yuglj9CfW0fbT5ZShZRzRmjWWKX4HvfLeJnNm0DhT6GBkPyQ0/zoY7iSJv8mnaRHEE5/GUk4BTLhge2yy0AcGWrgH7VPDSs+NdH8z4R7fJgWOL8EJl3Yxzuoiub9xFk8/VkZ9OLnK1WjSTtHcdog3L7dBJYVmKbnz3rKH/PIwxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175499; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRu5z9+3cfXzheoqmYnrL6PhWQJPROjux+y9kKrnYZRqVaY0crc+1GHeCilzB+VI/NXWJM7Mo05Eb2VgZoc24N2Tg184aU2Ohs1UtCeVAnUkKign3Vclnhbe8tzTbRSFiOwxbysShPE/h3wuIY/kyRg+OvORgg8FdHoshQv0kag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B573068D05; Tue, 19 May 2026 09:24:54 +0200 (CEST)
Date: Tue, 19 May 2026 09:24:54 +0200
From: Christoph Hellwig <hch@lst.de>
To: Martin Wilck <martin.wilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microchip.com>,
	ranjan.kumar@broadcom.com, linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>, mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH v3 0/2] Fix SAS wildcard scan on smartpqi and other
 controllers
Message-ID: <20260519072454.GA10928@lst.de>
References: <20260513174236.430465-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513174236.430465-1-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

