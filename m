From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 7/8] nvmet/admin-cmd: Hookup T10-PI to ID_NS.ms +
	ID_NS.dps feature bits
Date: Thu, 9 Jun 2016 15:52:42 +0200
Message-ID: <20160609135242.GA29981@lst.de>
References: <1465281416-28355-1-git-send-email-nab@linux-iscsi.org> <1465281416-28355-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54270 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbcFINwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2016 09:52:46 -0400
Content-Disposition: inline
In-Reply-To: <1465281416-28355-8-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>

FYI: NVMf requires metadata to be interleaved in the data, and you
need to indicate that in the Identify data.  Note that this is only
a requirement for the on the wire format and for the way the Namespaces are
exposed at the protocol level as RDMA HCA and FB HBAs should still
be able to handle our separate SGL.
