From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] fdomain: Add ISA bus support
Date: Mon, 13 May 2019 00:09:04 -0700
Message-ID: <20190513070904.GB31342@infradead.org>
References: <20190510212335.14728-1-linux@zary.sk>
 <20190510212335.14728-2-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190510212335.14728-2-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 10, 2019 at 11:23:35PM +0200, Ondrej Zary wrote:
> Add Future Domain 16xx ISA SCSI support card support.
> 
> Tested on IBM 92F0330 card (18C50 chip) with v1.00 BIOS.

Where did you find that thing? :)

> 
> Signed-off-by: Ondrej Zary <linux@zary.sk>

The driver looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
