From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] qla2xxx: remove stub qlt_check_srr_debug()
Date: Wed, 28 May 2014 04:12:43 -0700
Message-ID: <20140528111243.GA32216@infradead.org>
References: <1400940192.22523.59.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400940192.22523.59.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 24, 2014 at 04:03:12PM +0200, Paul Bolle wrote:
> qlt_check_srr_debug() was added in v3.5. It is a stub function unless
> CONFIG_QLA_TGT_DEBUG_SRR is defined. But CONFIG_QLA_TGT_DEBUG_SRR will
> never be defined, because the Kconfig symbol QLA_TGT_DEBUG_SRR was never
> added to the tree.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
