From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/23] scsi: introduce a result field in struct
        scsi_request
Date: Thu, 20 Apr 2017 07:17:30 +0200
Message-ID: <20170420051730.GA10897@lst.de>
References: <20170419192708.22098-1-hch@lst.de> <20170419192708.22098-9-hch@lst.de> <yq160hzsvkr.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq160hzsvkr.fsf@oracle.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 19, 2017 at 09:43:00PM -0400, Martin K. Petersen wrote:
> Really wish we could just obliterate drivers/ide.

Same here.  It's been _the_ major pain point for doing block layer
heavy lifting for the last 1 or two years.
