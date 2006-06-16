From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [RFC] qla4xxx: TODO for re-submission
Date: Fri, 16 Jun 2006 15:32:02 -0700
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC07176502@AVEXCH1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:12636 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751526AbWFPWcF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 18:32:05 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>
Cc: Doug Maxey <dwm@bebe.enoyolf.org>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com, David Wagner <david.wagner@qlogic.com>

> 
> So normally when you say target you mean portal. I mean for
sendtargets
iSCSI Target when there is an iSCSI Name associated with it, otherwise a
portal. I guess it would be clear to say Target Portal and Node instead.

> we set a portals as persistent not a whole target right (this is from
> jsut using iscli)? For iSNS, can't we get updates that there are new
> portals popping in the san? You are not saying that normally we want
to
> handle this by starting up a config app and setting them as
persistent.
That is correct we should field SCN (state change notification) and ESI
(entity status inquiry) events.
> I thought we would want to dyncallically add them to the system.
That is correct.
> 
> What is the point of using iSNS and setting the targets as persistent
in
> the initiator DB anyways? I thought one of the benefits of iSNS is
that
> we would manage all the targets and initiator access from a central
> location?
The HBA architecture allows any iSCSI Target Node or Portal (in case of
Send targets) to be made persistent. It is up to the user to determine
which ones need to be persistent.

