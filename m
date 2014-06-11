From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 11 Jun 2014 07:31:28 -0700
Message-ID: <20140611143128.GA30904@infradead.org>
References: <20140519140614.GA12183@infradead.org>
 <20140611120143.GA26071@infradead.org>
 <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 11, 2014 at 07:17:34AM -0700, James Bottomley wrote:
> No, I was waiting to check if there was any reason to have them split,
> but I think we've scope today or tomorrow.
> 
> The only other outstanding thing is the fsync bug fix, which is waiting
> Jens' investigation of the block issues it may cause, but I'm inclined
> to send it anyway and fix up block later if there's a problem.

There's various fixes marked for stable from Paolos virtio_scsi update,
which he asked to be considered for 3.16, including a core one:

  [PATCH v3 4/6] scsi_error: fix invalid setting of host byte

also

  [PATCH] sd: bad return code of init_sd

seems like another candidate for 3.16.
