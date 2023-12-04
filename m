Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A23CB
	for <linux-scsi@vger.kernel.org>; Mon,  4 Dec 2023 00:04:49 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93E3368BEB; Mon,  4 Dec 2023 09:04:46 +0100 (CET)
Date: Mon, 4 Dec 2023 09:04:45 +0100
From: Christoph Hellwig <hch@lst.de>
To: hare@kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] libfc: Fixup timeout error in fc_fcp_rec_error()
Message-ID: <20231204080445.GB30417@lst.de>
References: <20231129165832.224100-1-hare@kernel.org> <20231129165832.224100-3-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129165832.224100-3-hare@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
