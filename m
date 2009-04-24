From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 8 of 9] libata: Report disk alignment and physical block size
Date: Fri, 24 Apr 2009 06:32:10 -0600
Message-ID: <20090424123209.GB1926@parisc-linux.org>
References: <patchbomb.1240551141@sermon.lab.mkp.net> <47f4f448a804a2d24f10.1240551149@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47f4f448a804a2d24f10.1240551149@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2009 at 01:32:29AM -0400, Martin K. Petersen wrote:
> For disks with 4KB sectors, report the correct block size and alignment
> when filling out the READ CAPACITY(16) response.
> 
> This patch is based upon code from Matthew Wilcox' 4KB ATA tree.  I
> fixed the bug I reported a while back caused by ATA and SCSI using
> different approaches to describing the alignment.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
