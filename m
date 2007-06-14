From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] a100u2w: Convert into Linux style
Date: Fri, 15 Jun 2007 00:08:58 +0100
Message-ID: <20070614230858.GA29872@infradead.org>
References: <20070615001122.0abccc5e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758192AbXFNXJU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070615001122.0abccc5e@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mr Bowtie <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2007 at 12:11:22AM +0100, Alan Cox wrote:
> - Remove the BSD dual licence on the new work
> - Switch the if ALPHA to if __LP64__. (struct size is then right elsewhere)

__LP64__ is not a correct check unfortunately.  Please use
CONFIG_64BIT instead.
