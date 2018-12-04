From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v4 9/9] dmapool: debug: prevent endless loop in case of
	corruption
Date: Tue, 4 Dec 2018 12:18:01 -0800
Message-ID: <20181204201801.GS10377@bombadil.infradead.org>
References: <9e65ec2e-5e22-4f65-7b92-ca2af0c555f3@cybernetics.com>
	<20181113063601.GT21824@bombadil.infradead.org>
	<4dcb22b0-a348-841d-8175-e368f67f33c3@cybernetics.com>
	<20181204121443.1430883634a6ecf5f4a6a4a2@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181204121443.1430883634a6ecf5f4a6a4a2-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
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

On Tue, Dec 04, 2018 at 12:14:43PM -0800, Andrew Morton wrote:
> On Tue, 4 Dec 2018 11:22:34 -0500 Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org> =
wrote:
> =

> > On 11/13/18 1:36 AM, Matthew Wilcox wrote:
> > > On Mon, Nov 12, 2018 at 10:46:35AM -0500, Tony Battersby wrote:
> > >> Prevent a possible endless loop with DMAPOOL_DEBUG enabled if a buggy
> > >> driver corrupts DMA pool memory.
> > >>
> > >> Signed-off-by: Tony Battersby <tonyb-vFAe+i1/wJI5UWNf+nJyDw@public.gmane.org>
> > > I like it!  Also, here you're using blks_per_alloc in a way which isn=
't
> > > normally in the performance path, but might be with the right config
> > > options.  With that, I withdraw my objection to the previous patch and
> > >
> > > Acked-by: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > >
> > > Andrew, can you funnel these in through your tree?  If you'd rather n=
ot,
> > > I don't mind stuffing them into a git tree and asking Linus to pull
> > > for 4.21.
> > >
> > No reply for 3 weeks, so adding Andrew Morton to recipient list.
> > =

> > Andrew, I have 9 dmapool patches ready for merging in 4.21.=A0 See Matt=
hew
> > Wilcox's request above.
> > =

> =

> I'll take a look, but I see that this v4 series has several review
> comments from Matthew which remain unresponded to.  Please attend to
> that.

I only had a review comment on 8/9, which I then withdrew during my review
of patch 9/9.  Unless I missed something during my re-review of my response=
s?

> Also, Andy had issues with the v2 series so it would be good to hear an
> update from him?

Certainly.
