From: Ondrej Zary <linux@zary.sk>
Subject: Re: [PATCH 2/2] fdomain: Add ISA bus support
Date: Mon, 13 May 2019 17:54:11 +0200
Message-ID: <201905131754.11791.linux@zary.sk>
References: <20190510212335.14728-1-linux@zary.sk> <20190510212335.14728-2-linux@zary.sk> <20190513070904.GB31342@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190513070904.GB31342@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 13 May 2019 09:09:04 Christoph Hellwig wrote:
> On Fri, May 10, 2019 at 11:23:35PM +0200, Ondrej Zary wrote:
> > Add Future Domain 16xx ISA SCSI support card support.
> > 
> > Tested on IBM 92F0330 card (18C50 chip) with v1.00 BIOS.
> 
> Where did you find that thing? :)

eBay :) There are also some PCMCIA cards there.
 
> > 
> > Signed-off-by: Ondrej Zary <linux@zary.sk>
> 
> The driver looks fine to me:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 


-- 
Ondrej Zary
