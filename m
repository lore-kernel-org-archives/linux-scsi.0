From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 1/4] target: Add target_submit_cmd_map_sgls for SGL
 fabric memory passthrough
Date: Wed, 3 Oct 2012 07:48:38 -0400
Message-ID: <20121003114838.GB16209@infradead.org>
References: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
 <1349212618-348-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41721
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935Ab2JCLsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2012 07:48:38 -0400
Content-Disposition: inline
In-Reply-To: <1349212618-348-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>

On Tue, Oct 02, 2012 at 09:16:55PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new target_submit_cmd_map_sgls() to pass pre-allocated
> SGL memory using transport_generic_map_mem_to_cmd() logic into the generic
> target submit I/O codepath.
> 
> It also adds a target_submit_cmd() wrapper around target_submit_cmd_map_sgls()
> for existing fabric code that already assumes internal target-core SGL memory
> allocation.
> 
> (v2: Rename to target_submit_cmd_map_sgls + drop TARGET_SCF_MAP_MEM flag
>      in favor of non zero sgl_count check)

The flag is still added, even if it's not actually used in this version.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
