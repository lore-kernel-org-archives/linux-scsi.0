From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [0/3]   qla2xxx: new experimental changes...
Date: Fri, 04 Feb 2005 15:11:21 -0800
Message-ID: <1107558681.15462.49.camel@plap.san.rr.com>
References: <1107544908.14183.11.camel@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from avexch01.qlogic.com ([198.70.193.200]:4927 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S264888AbVBDXLG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Feb 2005 18:11:06 -0500
In-Reply-To: <1107544908.14183.11.camel@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-02-04 at 11:21 -0800, Andrew Vasquez wrote:
>
> Here's the breakdown of patches being submitted:
> 

Not sure what's going on with VGER, but several folks appear to be
having some difficulties getting the patches (including my own
@pobox.com account).  

All the patches can be found at the following URL:

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b10k/


>      1. Remove internal command queuing.  This entails removal of the
>         driver's *_queue lists as well as modifications and removal of
>         routines which used them.  With the queuing removed -- the
>         driver will be unable to tolerate cable-pulls.  Thus we depend
>         on the next patch for support.

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b10k/10-int_q_removal.diff


>      2. Add initial support for FC remote port infrastructure.  This
>         patch is based off the proposal submitted by James Smart:
>         ([Patch RFC ] Update FC transport for FC Remote Ports)
>         http://marc.theaimsgroup.com/?l=linux-scsi&m=110187926413504&w=2

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b10k/11-fc_rport_adds.diff

>      3. Remove internal lun discovery routines and support structures.
>         The mid-layer has a more exhaustive and fully capable set of
>         functions for lun discovery.
> 

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b10k/12-discovery_removal.diff



And a final incremental patch which fixes some backout problems with
patch #1:

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.02b10k/13-sm_fixes.diff


I apologize for the confusion (still not sure what's going on).

--
Andrew
