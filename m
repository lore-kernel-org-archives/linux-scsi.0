From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] tcm_loop: Convert I/O path to use
 target_submit_cmd_map_mem
Date: Tue, 2 Oct 2012 11:18:36 -0400
Message-ID: <20121002151835.GB21786@infradead.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
 <1349162147-29098-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1349162147-29098-3-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2012 at 07:15:45AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts tcm_loop to use target_submit_cmd_map_mem() for
> I/O submission and mapping of pre-allocated SGL memory from incoming
> scsi_cmnd -> se_cmd descriptors.
> 
> This includes removing the original open-coded fabric uses of target
> core callers to support transport_generic_map_mem_to_cmd() between
> target_setup_cmd_from_cdb() and transport_handle_cdb_direct() logic.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
