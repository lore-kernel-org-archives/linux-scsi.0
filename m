From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 RESENDv2 6/9] target: Rename core_tpg_post_dellun to
	remove_lun
Date: Tue, 24 Jun 2014 14:27:09 +0200
Message-ID: <20140624122709.GD9444@lst.de>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com> <1403567738-13310-7-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403567738-13310-7-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 23, 2014 at 04:55:35PM -0700, Andy Grover wrote:
> A clearer name, now that pre_dellun is gone.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>

Looks good, but might be worth merging into the previous patch.

Reviewed-by: Christoph Hellwig <hch@lst.de>
