From: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Subject: RE: Unable to set hostid in sym53c8xx module
Date: Wed, 20 Oct 2004 09:54:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7AAD212492598A4A92463C3F5D34C54F195127@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxl.tiscali.de ([194.162.162.200]:47116 "EHLO mxl.tiscali.de")
	by vger.kernel.org with ESMTP id S270057AbUJTHyO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 03:54:14 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Reinhold Fischer <news4reini123@aon.at>
Cc: linux-scsi@vger.kernel.org

Hello Reinhold, 

see this thread:
http://marc.theaimsgroup.com/?l=linux-scsi&m=109664449632539&w=2 
It's a known problem and Matthew Wilcox is currently working on this
issue. 

Bye, Robert

> Hi!
> 
> I have a problem with setting the hostid to something other 
> than #7 in the sym53c8xx module with kernel 2.6.8.1 on Debian 
> GNU/Linux 3.1 (Sarge), see below.
> 
> With kernel 2.4.27 all works fine.
> 
