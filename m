From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol
 dependency
Date: Wed, 14 Dec 2016 13:18:23 -0800
Message-ID: <20161214211823.GC14133@infradead.org>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 - the new qla2x00_free_fcport is entirely pointless, please drop
   that part of the patch (and even if it wasn't pointless it should
   have been a patch on it's own)
 - please use struct names and not typedefs for your new structures
 - pretty much avery single items in your list should be a separate
   patch.  And some of them are actively counterproductive and should
   be dropped:

        - Remove direct access of scsi_status field in se_cmd
	- Remove se_cmd from qlt_do_ctio_completion
	- Remove se_cmd access in srr code section
	- Move se_cmd struct outside of qla_tgt_cmd/qla_tgt_mgmt_cmd.
