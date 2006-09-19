From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 14:31:57 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CDD4@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:64746 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751141AbWISUcB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 16:32:01 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Darrick J. Wong wrote:

> Douglas Gilbert wrote:
> 
> > With the mptsas driver you can use smp_utils to look
> > at that expander via /dev/mptctl ('modprobe mptctl' first).
> > To get an overview of what the expander sees, try:
> >  # smp_discover -mb /dev/mptctl
> 
> Unfortunately, I see this:
> 


You need to pass the sas address of the expander.

./smp_discover --sa=sas_address /dev/mptctl

where sas_address can be found in
/sys/class/sas_device/expander-X:0/sas_address
