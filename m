From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC] Make the SCSI mempool allocations variable
Date: Tue, 9 Mar 2004 22:21:20 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040310062120.GN148048@sgi.com>
References: <1078858977.1756.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:8743 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262528AbUCJGVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 01:21:48 -0500
Content-Disposition: inline
In-Reply-To: <1078858977.1756.40.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mpm@waste.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 09, 2004 at 02:02:55PM -0500, James Bottomley wrote:
> Based on Jeremy's request to increase max_phys_segments, this is the way
> to do it (SCSI_MAX_PHYS_SEGMENTS) is the value that gets set as the
> queue's max_phys_segments.
> 
> I have to say that when I tried raising it to 256 and hammering a 10GB
> ext2 filesystem, I still didn't generate any >128 segment requests, so
> I'm dubious that raising it has any benefit at all, but feel free to try
> it and publish the figures.
> 
> I did wonder if lowering it might help improve the memory footprint for
> some embedded systems, so I set it up to be lowered as far as 32.
> 
> James

Thanks, James!

I promise that we will take advantage of this, but it might take a
couple of months.  As you point out, the filesystem code also has
to deliver the larger requests.

I'll try a couple of tests with XFS and block device direct I/O.

jeremy
