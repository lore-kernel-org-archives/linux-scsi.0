From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Thin provisioning fixes (take 3)
Date: Thu, 26 Nov 2009 11:09:40 -0600
Message-ID: <1259255380.7584.64.camel@mulgrave.site>
References: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1259254843-8326-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, hch@infradead.org, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-11-26 at 12:00 -0500, Martin K. Petersen wrote:
> Changes since last kit:
> 
>  - Patch 1 (block): Wire up an ioctl that reports whether the
>    block device zeroes after discard
> 
>  - Patch 2 (sd): Tweak max_discard_sectors reporting
> 
>  - Patch 3 (scsi, new): Retry temporary TP write errors
> 
>  - Patch 4 (libata): No change
> 
>  - Patch 5 (libata): Switch to a bytes-in, bytes-out convention
>    for ata_set_lba_range_entries() to make things more clear
> 
> I think we need a bit R&D wrt. discard coalescing and I doubt
> we'll have that ready for the merge window.  So I suggest we
> stick with the current loop-over-max-discard-sectors approach for
> 2.6.32.

So you forgot to specify ordering.  I think the right ordering is that
actually, there isn't any.  Jens can take 1, I can take 2,3 and Jeff can
take 4,5 without running any postmerge trees ... is that correct?

James


