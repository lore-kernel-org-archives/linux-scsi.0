From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 3/4] target: Fix change depth se_session reference
	usage
Date: Wed, 13 Jan 2016 09:27:38 +0100
Message-ID: <20160113082738.GA13158@lst.de>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com> <1452457724-10629-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452457724-10629-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>  int core_tpg_set_initiator_node_queue_depth(
>  	struct se_portal_group *tpg,
> -	unsigned char *initiatorname,
> +	struct se_node_acl *acl,
>  	u32 queue_depth,
>  	int force)

And while we're at it - the tpg should be dropped as well, we can
get it from acl->se_tpg trivially.
