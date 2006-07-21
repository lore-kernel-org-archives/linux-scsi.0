From: egoggin@emc.com
Subject: RE: [PATCH RFC] move scsi parts of dm hw handlers to scsi layer
Date: Fri, 21 Jul 2006 15:33:31 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E41491BE@CORPUSMX40A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:44766 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S1751119AbWGUTla (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 15:41:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: michaelc@cs.wisc.edu, dm-devel@redhat.com, linux-scsi@vger.kernel.org, agk@redhat.com

 

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Hannes Reinecke
> Sent: Friday, July 21, 2006 3:31 PM
> To: goggin, edward
> Cc: michaelc@cs.wisc.edu; dm-devel@redhat.com; 
> linux-scsi@vger.kernel.org; agk@redhat.com
> Subject: RE: [PATCH RFC] move scsi parts of dm hw handlers to 
> scsi layer
> 
> Am Fr 21.07.2006 21:10 schrieb Edward Goggin <egoggin@emc.com>:
> 
> > > IIRC this is
> > > 
> > > 'DGC' 'DISK'
> > > 'DGC' 'RAID 10'
> > > 'DGC' 'RAID 5'
> > 
> > And 'DGC' 'LUNZ'
> > 
> Yeah. But I left that one out as there is no device attached to it
> so we're unlikely to require a hw handler, or?

Isn't the scsi hw handler independent of DM though?  Also, even in
the DM case, it is useful to be able to parse sense codes associated
with failed IO to a LUNZ CLARiiON logical unit.

> 
> > What about supporting a wildcard model string?
> > 
> Well, we're having that.
> So 'DGC' 'DISK' and
> 'DGC' 'RAID*' should be okay.
> 
> Cheers,
> 
> Hannes
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
