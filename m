From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] g_NCR5380: Reduce overrides[] from array to struct
Date: Sun, 25 Sep 2016 16:46:47 -0700
Message-ID: <20160925234647.GB7312@infradead.org>
References: <1474743545-4731-1-git-send-email-linux@rainbow-software.org>
 <1474743545-4731-3-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474743545-4731-3-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Sep 24, 2016 at 08:59:04PM +0200, Ondrej Zary wrote:
> Remove compile-time card type definition GENERIC_NCR5380_OVERRIDE.
> Then remove all code iterating the overrides[] array and reduce it to
> struct card.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Looks great!

Reviewed-by: Christoph Hellwig <hch@lst.de>
