From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: [ofa-general] Re: [PATCH trivial] include linux/mutex.h from
	scsi_transport_iscsi.h
Date: Wed, 25 Jul 2007 22:12:57 +0300
Message-ID: <20070725191257.GA2311@mellanox.co.il>
References: <20070725110907.GF3826@mellanox.co.il> <46A79C00.200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <46A79C00.200@cs.wisc.edu>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Roland Dreier <rdreier@cisco.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@dev.mellanox.co.il>, general@lists.openfabrics.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

> Quoting Mike Christie <michaelc@cs.wisc.edu>:
> Subject: Re: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
> 
> Michael S. Tsirkin wrote:
> >scsi/scsi_transport_iscsi.h uses struct mutex, so while
> >linux/mutex.h seems to be pulled in indirectly
> >by one of the headers it includes, the right thing
> >is to include linux/mutex.h directly.
> >
> 
> Is that part about always including the header directly right?

Think so. Analogous patches by me has been accepted in various
subsystems. See e.g. f8916c11a4dc4cb2367e9bee1788f4e0f1b4eabc.

> If so 
> then were you going to include list.h too,

Makes sense. I'll repost.

> and were you going to fix up 
> some of the other iscsi code?

Not at the moment.
The reason I noticed this is because I'm doing some other project.
I'll post patches for other files if/when I notice any issues.

-- 
MST
