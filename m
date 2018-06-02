From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] scsi: sd_zbc: Fix potential memory leak
Date: Sat, 2 Jun 2018 15:22:21 +0200
Message-ID: <20180602132221.GI31493@kroah.com>
References: <20180531103124.21532-1-damien.lemoal@wdc.com>
 <20180531103124.21532-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531103124.21532-2-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, May 31, 2018 at 07:31:23PM +0900, Damien Le Moal wrote:
> [Backport of upstream commit 0aa3fdb8b3a6df3c2e3b61dbfe079db9d30e03cd]

That is not what this commit id is :(

Please fix up and resend the series.

thanks,

greg k-h
