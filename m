From: Oliver Xymoron <oxymoron@waste.org>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Wed, 11 Sep 2002 16:38:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020911213811.GF31597@waste.org>
References: <20020911191701.GE1212@marowsky-bree.de> <200209111937.g8BJbfQ02442@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209111937.g8BJbfQ02442@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Lars Marowsky-Bree <lmb@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 11, 2002 at 02:37:40PM -0500, James Bottomley wrote:
> lmb@suse.de said:
> >  and if the device mapper could have the notion of "to what topology
> > group does this device belong to", or even "distance metric (without
> > going into further detail on what this is, as long as it is consistent
> > to the physical layer) to the current CPU" (so that the shortest path
> > in NUMA could be selected), that would be kinda cool ;-) And doesn't
> > seem too intrusive.
> 
> I think I see driverfs as the solution here.  Topology is deduced by examining 
> certain device and HBA parameters.  As long as these parameters can be exposed 
> as nodes in the device directory for driverfs, a user level daemon map the 
> topology and connect the paths at the top.  It should even be possible to 
> weight the constructed multi-paths.
> 
> This solution appeals because the kernel doesn't have to dictate policy, all 
> it needs to be told is what information it should be exposing and lets user 
> level get on with policy determination (this is a mini version of why we 
> shouldn't have network routing policy deduced and implemented by the kernel).

Not coincidentally, network routing policy _is_ multipath config in
the iSCSI or nbd case.

-- 
 "Love the dolphins," she advised him. "Write by W.A.S.T.E.." 
