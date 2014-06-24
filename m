From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 07:03:59 -0700
Message-ID: <20140624140359.GA4599@infradead.org>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
 <1402477799-24610-2-git-send-email-sagig@mellanox.com>
 <53A920B2.9060503@cs.wisc.edu>
 <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
Sender: target-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 24, 2014 at 08:53:25AM -0400, Martin K. Petersen wrote:
> Oh, I see. So things break because iSCSI uses scsi_transfer_length()
> where the scatterlist length was used in the past.
> 
> How about this?

This fixes the regression for me.
