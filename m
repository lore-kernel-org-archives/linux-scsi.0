From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 3/4] target: Fix change depth se_session reference
 usage
Date: Wed, 13 Jan 2016 00:58:23 -0800
Message-ID: <1452675503.27508.52.camel@haakon3.risingtidesystems.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
	 <1452457724-10629-4-git-send-email-nab@daterainc.com>
	 <20160113082738.GA13158@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160113082738.GA13158@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 09:27 +0100, Christoph Hellwig wrote:
> >  int core_tpg_set_initiator_node_queue_depth(
> >  	struct se_portal_group *tpg,
> > -	unsigned char *initiatorname,
> > +	struct se_node_acl *acl,
> >  	u32 queue_depth,
> >  	int force)
> 
> And while we're at it - the tpg should be dropped as well, we can
> get it from acl->se_tpg trivially.

Done.
