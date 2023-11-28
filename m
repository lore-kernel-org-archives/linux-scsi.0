Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3D8D72;
	Tue, 28 Nov 2023 04:53:59 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 72A28227A87; Tue, 28 Nov 2023 13:53:55 +0100 (CET)
Date: Tue, 28 Nov 2023 13:53:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v15 00/19] Improve write performance for zoned UFS
 devices
Message-ID: <20231128125355.GA7613@lst.de>
References: <20231114211804.1449162-1-bvanassche@acm.org> <20231127070939.GB27870@lst.de> <a9748872-0608-4ab9-8986-a82eff17ca9f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9748872-0608-4ab9-8986-a82eff17ca9f@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 11:35:48AM -0800, Bart Van Assche wrote:
> Here is some additional background information:

I know the background.  I also know that JEDEC did all this aginst
better judgement and knowing the situation.  We should not give them
their carrot after they haven't even been interested in engaging.

