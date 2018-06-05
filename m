From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 0/2] 4.14 long term stable ZBC fixes
Date: Tue, 5 Jun 2018 12:18:15 +0200
Message-ID: <20180605101815.GB26129@kroah.com>
References: <20180604080413.30747-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180604080413.30747-1-damien.lemoal@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 04, 2018 at 05:04:11PM +0900, Damien Le Moal wrote:
> Patch 4b433924b275 ("scsi: sd_zbc: Fix potential memory leak") was added in
> 4.16 and 4.15 stable but did not make it to long term stable 4.14 (as far as I
> can tell).
> 
> Patch ccce20fc7968 ("scsi: sd_zbc: Avoid that resetting a zone fails
> sporadically") is included in 4.16 but does not apply to 4.15 stable nor to
> 4.14 long term stable and requires extensive modifications.
> 
> This small series provides a backport of both patches against 4.14. Please
> consider these patches for inclusion in this long term stable kernel.

Both now queued up, thanks.

greg k-h
