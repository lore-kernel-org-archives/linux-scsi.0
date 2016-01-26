From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-v2 3/3] target: Fix TAS handling for multi-session
	se_node_acls
Date: Tue, 26 Jan 2016 18:22:48 +0100
Message-ID: <20160126172248.GC3663@lst.de>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com> <1453513067-23169-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1453513067-23169-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

> -	if ((tmr_nacl && (tmr_nacl != cmd->se_sess->se_node_acl)) && tas) {
> +	if ((tmr_sess && (tmr_sess != cmd->se_sess)) && tas) {

Care to drop the pointless braces here if you touch this anyway?

	if (tmr_sess && tmr_sess != cmd->se_sess && tas)

Otherwise this looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
