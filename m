From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 9/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Tue, 4 Dec 2018 12:35:57 -0800
Message-ID: <20181204203557.GT10377@bombadil.infradead.org>
References: <9e65ec2e-5e22-4f65-7b92-ca2af0c555f3@cybernetics.com>
	<20181113063601.GT21824@bombadil.infradead.org>
	<4dcb22b0-a348-841d-8175-e368f67f33c3@cybernetics.com>
	<20181204121443.1430883634a6ecf5f4a6a4a2@linux-foundation.org>
	<20181204201801.GS10377@bombadil.infradead.org>
	<20181204122854.339503ccbbdc638940c9e1d0@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181204122854.339503ccbbdc638940c9e1d0-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 04, 2018 at 12:28:54PM -0800, Andrew Morton wrote:
> On Tue, 4 Dec 2018 12:18:01 -0800 Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > I only had a review comment on 8/9, which I then withdrew during my review
> > of patch 9/9.  Unless I missed something during my re-review of my responses?
> 
> And in 0/9, that 1.3MB allocation.
> 
> Maybe it's using kvmalloc, I didn't look.

Oh!  That's the mptsas driver doing something utterly awful.  Not the
fault of this patchset, in any way.
