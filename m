From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 RESENDv2 5/9] target: Change core_dev_del_lun to take
	a se_lun instead of unpacked_lun
Date: Tue, 24 Jun 2014 14:26:27 +0200
Message-ID: <20140624122627.GC9444@lst.de>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com> <1403567738-13310-6-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403567738-13310-6-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 23, 2014 at 04:55:34PM -0700, Andy Grover wrote:
> Remove core_tpg_pre_dellun entirely, since we don't need to get/check
> a pointer we already have.
> 
> Nothing else can return an error, so core_dev_del_lun can return void.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
