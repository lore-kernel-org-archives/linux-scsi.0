From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: remove REQ_OP_WRITE_SAME
Date: Fri, 5 May 2017 10:57:13 +0200
Message-ID: <20170505085713.GA5008@lst.de>
References: <20170412084809.8245-1-hch@lst.de> <yq1mvbjwwvl.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <yq1mvbjwwvl.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
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
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 13, 2017 at 10:23:10PM -0400, Martin K. Petersen wrote:
> The other thing that keeps me a bit on the fence is that a bunch of the
> plumbing to handle a bio with a payload different from bi_size is needed
> for the copy offload token. I'm hoping to have those patches ready for
> 4.13. Right now there are a bunch of places where handling of
> REQ_OP_COPY_IN and REQ_OP_COPY_OUT share conditionals with WRITE SAME.

Any chance to get a sneak preview of that work?
