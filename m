From: Jens Axboe <axboe@suse.de>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Sun, 27 Oct 2002 22:20:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027212035.GM3966@suse.de>
References: <20021026092943.GB14976@suse.de> <200210270050.g9R0oQe04795@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210270050.g9R0oQe04795@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

On Sat, Oct 26 2002, James Bottomley wrote:
> axboe@suse.de said:
> > Irk no, you cannot just clear valid information! This is _not_ a fix,
> > it's a hack.
> 
> > Use a different flag, or maybe use REQ_DONTPREP or similar. 
> 
> OK, what about this.  It uses REQ_DONTPREP, and could be a precursor
> to moving the SCSI subsystem to using the request prep function.

Sure that would suffice, but lets just move to the prep approach right
away. First just the global one, later we can do one per device type.

-- 
Jens Axboe

