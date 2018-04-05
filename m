From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] Fix DID_OK handling in __scsi_error_from_host_byte()
Date: Thu, 5 Apr 2018 10:50:24 +0200
Message-ID: <20180405085024.GB2286@lst.de>
References: <20180404175355.15982-1-bart.vanassche@wdc.com> <20180405084318.380ab452@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405084318.380ab452@pentland.suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 05, 2018 at 08:43:18AM +0200, Hannes Reinecke wrote:
> And a further nit-pick: the function is called
> __scsi_error_from_host_byte(), so it's only logical that it would only
> check the host_byte().
> What's wrong is the _usage_ here; after calling
> __scsi_error_from_host_byte() we need to check if the _other_ bits of
> the results are non-zero to end up with a valid result.
> 
> Hence I would advocate to either rename this function
> (__scsi_error_from_result() ?) or evaluate the remaining bits outside
> this function.
> 
> But I would advocate for the former; otherwise the same issue will crop
> up again in the future.

Please also drop the pointless double underscore prefix while at it,
otherwise fully agreed.
