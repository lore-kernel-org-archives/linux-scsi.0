From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/2] scsi: add a max_segment_size limitation to struct
	Scsi_Host
Date: Tue, 12 Apr 2016 01:35:31 +0200
Message-ID: <20160411233531.GA18851@lst.de>
References: <1460414846-29540-1-git-send-email-hch@lst.de> <1460414846-29540-2-git-send-email-hch@lst.de> <570C3400.9080503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <570C3400.9080503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 11, 2016 at 04:32:16PM -0700, Bart Van Assche wrote:
> Since Scsi_Host.max_segment_size is initialized to zero, shouldn't min() be 
> changed into min_not_zero()?

It probably should.  Thanks for catching this.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
