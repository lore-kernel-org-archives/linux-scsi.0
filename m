From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Wed, 28 May 2014 03:41:14 -0700
Message-ID: <20140528104114.GE13542@infradead.org>
References: <1400926433.31526.89.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1400926433.31526.89.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 24, 2014 at 12:13:53PM +0200, Paul Bolle wrote:
> The acornscsi driver was added in v2.1.88. It has always #undef-ed
> CONFIG_SCSI_ACORNSCSI_LINK near the top of acornscsi.c. And, just to be
> sure, it has also always triggered a preprocessor error if
> CONFIG_SCSI_ACORNSCSI_LINK was still defined. But, as far as I can see,
> it has never even been possible to set SCSI_ACORNSCSI_LINK through
> kconfig, or its predecessors, in the first place.
> 
> Let's remove the code involved.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

And I have to disagree with James here, removing code that isn't even
compiled always is an improvement, especially for an unmaintained
driver.
