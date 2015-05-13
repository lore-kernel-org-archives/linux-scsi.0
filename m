From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/12] target: Convert se_node_acl->device_list[] to RCU
 hlist
Date: Wed, 13 May 2015 01:46:11 -0700
Message-ID: <1431506771.26897.78.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-2-git-send-email-nab@daterainc.com>
	 <20150513063555.GA21770@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150513063555.GA21770@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-05-13 at 08:35 +0200, Christoph Hellwig wrote:
> Onemore comments from looking oer the RCU usage with all the patches
> applied:
> 
> In core_get_se_deve_from_rtpi we dereference lun->lun_sep, so
> either struct se_port needs to be switched to kfree_rcu,
> or we need to mirror the rtpi value into the se_lun.

Updated to use a mirror lun->lun_rtpi, with the assignment from sep_rtpi
occuring in core_dev_export() code.

Thanks HCH.
