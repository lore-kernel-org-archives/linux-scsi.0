From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: Fri, 25 Jul 2003 06:51:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B200D9937@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr01.intel.com ([192.55.52.18]:717 "EHLO hermes.fm.intel.com")
	by vger.kernel.org with ESMTP id S272064AbTGYNhJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 09:37:09 -0400
Received: from petasus.fm.intel.com (petasus.fm.intel.com [10.1.192.37])
	by hermes.fm.intel.com (8.11.6p2/8.11.6/d: outer.mc,v 1.66 2003/05/22 21:17:36 rfjohns1 Exp $) with ESMTP id h6PDl7002540
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2003 13:47:07 GMT
Received: from fmsmsxv040-1.fm.intel.com (fmsmsxv040-1.fm.intel.com [132.233.48.108])
	by petasus.fm.intel.com (8.11.6p2/8.11.6/d: inner.mc,v 1.35 2003/05/22 21:18:01 rfjohns1 Exp $) with SMTP id h6PDj3r00511
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2003 13:45:03 GMT
List-Id: linux-scsi@vger.kernel.org
To: "'Justin T. Gibbs'" <gibbs@scsiguy.com>, Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>, Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Cc: linux-scsi@vger.kernel.org

Let me second the recommendation to upgrade the aic79xx driver version.
I've seen packetizing problems with 1.3.0 that may apply here, but that was
resolved in 1.3.2 and greater.

Andy

-----Original Message-----
From: Justin T. Gibbs [mailto:gibbs@scsiguy.com] 
Sent: Thursday, July 24, 2003 5:58 PM
To: Thomas Beutin; Duncan Gibb
Cc: linux-scsi@vger.kernel.org
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)


> (Especially the current transfer rate on Channel A Target 1 is
> somewhat less than expected.)
> 
> Maybe there is a new driver by Justin Gibbs, but i didn't found
> anything for the 2.4.21 kernel in
> http://people.freebsd.org/~gibbs/linux/SRC/

The 2.4 archive should work on just about any 2.4.X kernel.
I would highly recoment upgrading from 1.3.0.

I'm still not clear on what your problem is.  Can you provide
a full dmesg from the system and any diagnostic messages the
driver generates?

--
Justin

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
