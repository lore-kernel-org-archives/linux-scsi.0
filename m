From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] current scsi-misc-2.5 scsi_lib.c needs init.h
Date: Thu, 5 Dec 2002 22:58:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021205225857.A12721@infradead.org>
References: <patmans@us.ibm.com> <200212052226.gB5MQjf05474@localhost.localdomain> <20021205145441.A10578@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021205145441.A10578@beaverton.ibm.com>; from patmans@us.ibm.com on Thu, Dec 05, 2002 at 02:54:41PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Dec 05, 2002 at 02:54:41PM -0800, Patrick Mansfield wrote:
> highmem.h does not include asm/highmem.h unless #ifdef CONFIG_HIGHMEM.
> 
> I changed my config to use highmem 4g, and it compiled OK.

Sorry for the breakage.  I'll do a sweep over all asm headers to get rid of
implicit inclusions of init.h (unless impossible, but I dount it)

