From: Tejun Heo <tj@kernel.org>
Subject: Re: TCG Opal support for libata
Date: Mon, 5 Jun 2017 15:30:08 -0400
Message-ID: <20170605193008.GA9399@htj.duckdns.org>
References: <20170604124225.27032-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170604124225.27032-1-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 04, 2017 at 02:42:19PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series adds support for using our new generic TCG OPAL code with
> SATA disks, and as side effect for SCSI disks (although so far it doesn't
> seem like none of those actually exist).

Applied 1-5 to libata/for-4.13.  Updated 4 for line continuation style
consistency as pointed out by Sergei.

Thanks.

-- 
tejun
