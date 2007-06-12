From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
Date: Tue, 12 Jun 2007 08:56:00 -0700
Message-ID: <20070612085600.72d02b19.kristen.c.accardi@intel.com>
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>
	<466DFDB5.9030901@gmail.com>
	<466E0642.5020506@linux.intel.com>
	<466E1D51.9070007@gmail.com>
	<466E1EC6.90509@linux.intel.com>
	<466E23AF.9060002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <466E23AF.9060002@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, jeff@garzik.org, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 Jun 2007 13:40:15 +0900
Tejun Heo <htejun@gmail.com> wrote:

> I don't think the end result will vary in any significant way.  My
> biggest argument for sw implementation is it can be used for other
> controllers.

What I had in mind when I created the new port operation "enable_pm"
was that other controllers (besides the ahci controller) could define their
own method of enabling power management.  Maybe for non-ahci controllers this
is a software based solution which uses generic SATA dipm/hipm stuff and 
polling.  

See patch 2/3 of this series for the implementation of this.

Kristen
