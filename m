From: berthiaume_wayne@emc.com
Subject: RE: [RFC] qla4xxx: TODO for re-submission
Date: Tue, 13 Jun 2006 08:16:46 -0400
Message-ID: <D364D39DAD21D444BAE2C70919B62809A0B573@CORPUSMX40A.corp.emc.com>
References: <448E3FA8.4050309@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:26250 "EHLO
	mexforward.lss.emc.com") by vger.kernel.org with ESMTP
	id S932083AbWFMMRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2006 08:17:36 -0400
Content-class: urn:content-classes:message
In-Reply-To: <448E3FA8.4050309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, dwm@bebe.enoyolf.org
Cc: michaelc@cs.wisc.edu, ravi.anand@qlogic.com, davidcs2005@gmail.com, duane.grigsby@qlogic.com, linux-scsi@vger.kernel.org

A one tool fits all is the best solution if your interest is to get
iSCSI and Linux accepted in the enterprise and, especially, the SMB
markets. This should be the goal.  

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
Sent: Tuesday, June 13, 2006 12:32 AM
To: Doug Maxey
Cc: Mike Christie; Ravi Anand; David Somayajulu; Duane Grigsby;
linux-scsi@vger.kernel.org
Subject: Re: [RFC] qla4xxx: TODO for re-submission

Doug Maxey wrote:
> Having a common solution (ala ethtool) for the user/admin, across all
> SWI, all HBAs, and all distros would be optimal in my view.  Although
> the QLogic tools are out there, they only work AFAIK, for the other,
> non-mainline drivers.   It is enough pain to manage the targets,  
> making one end of the configuration common would be a big bonus.


Why, in fact...  that's the purpose of blktool :)

Vendor-specific code in blktool is quite welcome.  The general idea is 
to manage various vendor-specific capabilities which fit common
patterns.

git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/blktool.git
http://sourceforge.net/projects/gkernel/

	Jeff


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
