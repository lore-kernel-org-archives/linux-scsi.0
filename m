Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22CF3D75D1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 07:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790320391; cv=none; b=RLo4pwdWf1nn2gMYY+6qszczdtCaXDIGnyaW2QLsr1QmKN6bgf80AQELq/o6ZqIGA5pQYwvKTJuZhyydw2QWQnxnZv8bM+O6UlZu8QJUZzOOWfIKJ4V1YNBYuCVSqL9IZq2D4AUWOhrnFQnOXac6mMubGxvbtdulkXUM5UPiLYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790320391; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kq2U4uVKnAleHIurTZcRlwy8kPeePXgNaw7Pmbbtl7ImPIt84nJstc18U6XwM2M7fuIO//xD/3AIQgwvKm6jRLj0NDGBlyFTchBZ4tI10uscb0rcVWvbfv+0vTRLbeZQMcGXN1Z7/bSV5tN4PbqjJIZ+IzYz/98YtNplVe9Bdo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D25E968C4E; Fri, 25 Sep 2026 09:13:06 +0200 (CEST)
Date: Fri, 25 Sep 2026 09:13:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 7/7] scsi: core: Enable lock context analysis for
 the scsi_debug driver
Message-ID: <20260925071306.GF4621@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org> <4e2a141483142d490753b07a118dacd1221294e8.1790290090.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e2a141483142d490753b07a118dacd1221294e8.1790290090.git.bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

