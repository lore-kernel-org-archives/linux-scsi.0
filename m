From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFC 4/8] p2pmem: Add debugfs "stats" file
Date: Wed, 5 Apr 2017 10:43:38 -0500
Message-ID: <003201d2ae23$6527ef10$2f77cd30$@opengridcomputing.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-5-git-send-email-logang@deltatee.com>
 <95928b70-0148-7297-8f5e-5031d996bb98@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <95928b70-0148-7297-8f5e-5031d996bb98-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Logan Gunthorpe' <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, "'James E.J. Bottomley'" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Jens Axboe' <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, 'Stephen Bates' <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, 'Max Gurtovoy' <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Dan Williams' <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Keith Busch' <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> 
> > +	p2pmem_debugfs_root = debugfs_create_dir("p2pmem", NULL);
> > +	if (!p2pmem_debugfs_root)
> > +		pr_info("could not create debugfs entry, continuing\n");
> > +
> 
> Why continue? I think it'd be better to just fail it.
> 

Because not having debugfs support isn't fatal to using p2pmem.  So I
believe it is better to continue.  But this is trivial, IMO, so either was
is ok with me.

> Besides, this can be safely squashed into patch 1.

Yes.
