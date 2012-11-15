From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] target: Add max_write_same_len device attribute
Date: Thu, 15 Nov 2012 05:53:12 -0500
Message-ID: <20121115105312.GC28956@infradead.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352405238-23267-3-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 08, 2012 at 08:07:17PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a new max_write_same_len device attribute for use with
> WRITE_SAME w/ UNMAP=0 backend emulation.
> 
> Also, update block limits VPD emulation code in spc_emulate_evpd_b0() to
> set the default MAXIMUM WRITE SAME LENGTH value of zero.

why do we need an exposed attribute for this?
