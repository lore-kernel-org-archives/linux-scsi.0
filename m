From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 9 of 9] libata: Media rotation rate and form factor heuristics
Date: Fri, 24 Apr 2009 06:30:54 -0600
Message-ID: <20090424123054.GA1926@parisc-linux.org>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <2fc5b2aa370a8ad47db1.1240551150@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2fc5b2aa370a8ad47db1.1240551150@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2009 at 01:32:30AM -0400, Martin K. Petersen wrote:
> This patch delegates setting the queue NONROT flag to SCSI.
> 
> It also provides new heuristics for parsing both the form factor and
> media rotation rate ATA IDENFITY words.
> 
> The reported ATA version must be 7 or greater and the device must return
> values defined as valid in the standard.  Only then are the
> characteristics reported to SCSI via the VPD B1 page.
> 
> This seems like a reasonable compromise to me considering that we have
> been shipping several kernel releases that key off the rotation rate bit
> without any version checking whatsoever.  With no complaints so far.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
