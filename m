From: Christopher Allen Wing <wingc@engin.umich.edu>
Subject: any experience with PCI Express parallel scsi controllers?
Date: Tue, 20 Feb 2007 10:10:11 -0500 (EST)
Message-ID: <Pine.LNX.4.63.0702200959540.12650@gx620.engin.umich.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srvr20.engin.umich.edu ([141.213.75.22]:55123 "EHLO
	srvr20.engin.umich.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965052AbXBTPdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 10:33:23 -0500
Received: from gx620.engin.umich.edu (IDENT:U2FsdGVkX19Vkn4zLiHFzTw1v4YBZhuN/6V24A1YWP0@gx620.engin.umich.edu [141.213.40.58])
	by srvr20.engin.umich.edu (8.13.6/8.13.6) with ESMTP id l1KFGUfY011704
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2007 10:16:31 -0500 (EST)
Received: from localhost (IDENT:U2FsdGVkX19N2vXlipYzgzvV3BL+BprHmeCudW6MlC8@localhost.localdomain [127.0.0.1])
	by gx620.engin.umich.edu (8.13.6/8.13.6) with ESMTP id l1KFABZR026683
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2007 10:10:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm trying to connect some older SCSI devices to new servers which only 
have PCI Express expansion slots.  Unfortunately it seems that there are 
very few parallel SCSI HBA cards available for PCI Express systems.  Most 
SCSI controller manufacturers are only selling PCI-X cards if you want 
parallel SCSI.


Has anyone else been in this situation?  One product that we found is a 
board sold by HP (HP SC11Xe) based on a LSI Logic chipset.  This is a PCI 
Express controller with a single U320 parallel SCSI channel.  It is 
reasonably priced ($200); unfortunately, the documentation on HP's web 
site states that it will only work with tape devices.  Is anyone familiar 
with this card who might know if this claim (that the card only works with 
tape drives) is true or false?

Otherwise, Adaptec does not seem to sell any parallel SCSI cards for PCI 
Express; there are a few expensive PCI Express RAID controllers out there 
with parallel SCSI but I don't need a hardware RAID controller.  There is 
also an ATTO Technology PCI Express card with parallel SCSI; it sells for 
around $500.


Any ideas or suggestions?


Thanks a lot,

Chris Wing
wingc@engin.umich.edu
