From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/9] cciss driver SCSI updates
Date: Sun, 28 Feb 2010 19:43:53 +0100
Message-ID: <20100228184353.GG5768@kernel.dk>
References: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, james.bottomley@suse.de, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 26 2010, Stephen M. Cameron wrote:
> The following series mainly fixes the scsi tape code in the cciss
> driver to take advantage of more scatter gather elements, enabling
> larger transfer sizes.  The first eight patches are mainly cleaning
> things up and getting ready for the 9th patch, which enables the
> SCSI half of the driver to use more than 31 scatter gather elements.
> 
> I've tested on 32-bit and 64-bit systems, and written out tapes
> with block sizes up to 2Mb.
> 
> These patches are vs. Jens's linux-2.6-block tree.

Thanks Stephen, applied.

-- 
Jens Axboe
