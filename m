From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 4/4] target: Obtain se_node_acl->acl_kref during
	get_initiator_node_acl
Date: Wed, 13 Jan 2016 09:49:22 +0100
Message-ID: <20160113084922.GA13617@lst.de>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com> <1452457724-10629-5-git-send-email-nab@daterainc.com> <20160112150941.GC2058@lst.de> <1452672028.27508.40.camel@haakon3.risingtidesystems.com> <20160113081518.GA12642@lst.de> <1452674288.27508.47.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452674288.27508.47.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 12:38:08AM -0800, Nicholas A. Bellinger wrote:
> Ok.  How about the following comment instead..?

That one looks correct.  I still don't think it adds much of a value,
though..
