From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 03 Dec 2003 11:03:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
	<1070464184.1771.33.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10413 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S265060AbTLCRDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 12:03:21 -0500
In-Reply-To: <1070464184.1771.33.camel@mulgrave> (James Bottomley's message
 of "03 Dec 2003 09:09:43 -0600")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On 03 Dec 2003, James Bottomley stated:
> On Wed, 2003-12-03 at 08:06, Naveen Burmi wrote:
>> PREVENT_DATA_CORRUPTION was based on our assumption which is not
>> correct and Linux SCSI subsystem is architected for zero copy,
>> therefore we are removing PREVENT_DATA_CORRUPTION.
> 
> Just as a matter of interest, *all* unix like operating systems have
> used a zero copy architecture (well, in SCSI; networking came a bit
> later) for at least the last decade, so you might want to check this
> assumption in other ports of your iscsi initiator.

And in non-ix OS's, too.

Naveen, is it intended that the iSCSI driver retry when the 0B/4705 is
detected, or will that sense code and COMMAND ABORT be passed up to the
SCSI layers for retry?

James, et al, do the SCSI layers retry on COMMAND ABORT?

I don't believe the SCSI layers retry on HARDWARE ERROR -- this is a
difference between how Solaris and Linux operate, for example, unless
I am misunderstanding or have obsolete information.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
   Active dissent has been part of American government since the
         Boston Tea Party, and will be until its end.
