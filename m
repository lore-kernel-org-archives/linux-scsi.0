From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 8 Jun 2010 09:15:35 +0200
Message-ID: <20100608071534.GA3263@schmichrtp.mainz.de.ibm.com>
References: <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <20100531144648.GA19068@schmichrtp.mainz.de.ibm.com>
 <yq11vcqlwp8.fsf@sermon.lab.mkp.net>
 <20100602133748.GA11196@schmichrtp.mainz.de.ibm.com>
 <20100602232039.GA8287@dastard>
 <yq139x3y411.fsf@sermon.lab.mkp.net>
 <20100604023253.GF19651@dastard>
 <yq1zkz6vmpu.fsf@sermon.lab.mkp.net>
 <4C0D2AD4.2020303@panasas.com>
 <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1sk4yvj0a.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Dave Chinner <david@fromorbit.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 07, 2010 at 01:40:21PM -0400, Martin K. Petersen wrote:
> >>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:
> 
> Boaz> Do you remember some performance numbers that show degradation /
> Boaz> sameness?
> 
> Boaz> What type of work loads?
> 
> I haven't been using XFS much for over a year.  I'm using an internal
> async I/O tool and btrfs for most of my DIX/DIF testing these days.
> 
> But my original changes were along the lines of what Jan mentioned
> earlier (hooking into page_mkwrite and waiting for writeback.  I could
> have sworn that I only did it for ext[23] and that XFS waited out of the
> box but git proves me wrong).  Anyway, I'll try to get some benchmarking
> happening later this week.

Is there a patch with this change available somewhere? It might be
useful to patch a kernel with this XFS change for reliable DIF/DIX
testing.

> This won't fix things completely, though.  ext2fs, for instance,
> frequently changes metadata buffers in flight so it trips the guard
> check in no time.
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
