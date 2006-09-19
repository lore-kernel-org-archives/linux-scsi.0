From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 14:18:36 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CDC0@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46824 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1752016AbWISUSj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 16:18:39 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Tuesday, September 19, 2006 1:15 PM,  Darrick J. Wong wrote:

> Alexis and I connected both a Adaptec 9410 and a LSI 1064E 
> SAS initiator
> to an expander.  Both machines saw the disks attached to the expander,
> and both could send I/Os to the disks.  So far, so good.
> 
> We then connected a SATA disk to the expander.  libsas BUGd up in
> sas_ex_discover_end_dev (sas_expander.c:636):
> 
> BUG_ON(sas_port_add(phy->port) != 0);
> 

Which expander are you using?  I believe James has some sata work
arounds
for the sasx12, which has byte ordering issues.

Eric
