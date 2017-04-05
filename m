From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: always use REQ_OP_WRITE_ZEROES for zeroing offload
Date: Wed, 5 Apr 2017 14:08:26 +0200
Message-ID: <20170405120826.GA2275@lst.de>
References: <20170331163313.31821-1-hch@lst.de> <yq1vaqjt74b.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <yq1vaqjt74b.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 05, 2017 at 07:40:36AM -0400, Martin K. Petersen wrote:
> > This series makes REQ_OP_WRITE_ZEROES the only zeroing offload
> > supported by the block layer, and switches existing implementations
> > of REQ_OP_DISCARD that correctly set discard_zeroes_data to it,
> > removes incorrect discard_zeroes_data, and also switches WRITE SAME
> > based zeroing in SCSI to this new method.
> 
> Very, very nice. I think this is the correct approach.
> 
> I'm going to send two follow-up patches that allow us to use UNMAP for
> discards and WRITE SAME w/ UNMAP for zeroout. That appears to be the
> preferred configuration for most storage devices.

Thanks, I'll resend it with your nitpicks fixed, your follow on
patches tacked on and the various reviewed-by tags in a bit.
