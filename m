From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 1/4] tcm_fc: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Tue, 12 Jan 2016 23:19:06 -0800
Message-ID: <1452669546.27508.25.camel@haakon3.risingtidesystems.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
	 <1452457724-10629-2-git-send-email-nab@daterainc.com>
	 <20160112150200.GA2058@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160112150200.GA2058@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-01-12 at 16:02 +0100, Christoph Hellwig wrote:
> On Sun, Jan 10, 2016 at 08:28:41PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch does a simple conversion of tcm_fc code to use
> > proper modern core_tpg_get_initiator_node_acl() lookup using
> > se_node_acl->acl_kref, and drops the legacy list walk from
> > ft_acl_get().
> > 
> > Note the original lookup also took node_name into account,
> > but since ft_init_nodeacl() only ever sets port_name for
> > se_node_acl->acl_group within configfs, this is purely
> > a mechanical change.
> 
> Please remove ft_acl_get and fold it's new implementation into the
> caller.  The later patches actually remove the usage of it but keep it
> around, but it would be much better to kill it off here.

Done.
