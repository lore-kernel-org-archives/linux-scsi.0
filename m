From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fdomain: Remove BIOS-related code from core
Date: Mon, 13 May 2019 00:07:08 -0700
Message-ID: <20190513070708.GA31342@infradead.org>
References: <20190510212335.14728-1-linux@zary.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190510212335.14728-1-linux@zary.sk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@zary.sk>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 10, 2019 at 11:23:34PM +0200, Ondrej Zary wrote:
> Move all BIOS signature and base handling to (currently not merged) ISA bus
> driver.
> 
> Signed-off-by: Ondrej Zary <linux@zary.sk>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
