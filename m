From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC] Make the SCSI mempool allocations variable
Date: Wed, 10 Mar 2004 22:38:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311063805.GM618504@sgi.com>
References: <1078858977.1756.40.camel@mulgrave> <20040310100740.GA619810@sgi.com> <1078932577.10834.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:32063 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S261603AbUCKGiq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2004 01:38:46 -0500
Content-Disposition: inline
In-Reply-To: <1078932577.10834.44.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mpm@waste.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 10, 2004 at 10:29:36AM -0500, James Bottomley wrote:
> 
> The best course of action is probably to put the patch in (since it has
> its current default at 128, it will change nothing) so that people who
> wish to play with increasing the allocation can.
> 
> To address the question of how you set this, I'd like more information
> about which filesystems and workloads find this useful, perhaps with a
> view to tying it to an indirect config option (CONFIG_ENTERPRISE or
> something).
> 
> James

Most of our users that would benefit from this would fall into the
"HPC" segment.  HPC meaning High Performance Computing.  That's
probably not very descriptive.  There is typically a lot of floating
point and large data sets.

There may be a database involved, but it's not traditional commercial
transaction processing, which typically has very small I/O requests.

Other users would be Broadcast, where they stream A/V streams to/from
a RAID device.

There are also sites that store large amounts of data keeping track
of things (people/places/etc.), looking for things, etc.

Maybe CONFIG_HPC or CONFIG_HIGH_BANDWIDTH_IO.  The longer and
clumsier the name, the more descriptive.  :-)

Filesystems?  Is there anything other than XFS?  :-)  :-)

jeremy
