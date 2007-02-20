From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: any experience with PCI Express parallel scsi controllers?
Date: Tue, 20 Feb 2007 10:04:32 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D705ACFEF@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39111 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030313AbXBTREu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Feb 2007 12:04:50 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christopher Allen Wing <wingc@engin.umich.edu>, linux-scsi@vger.kernel.org

On Tuesday, February 20, 2007 8:10 AM,  Christopher Allen Wing wrote:
> Has anyone else been in this situation?  One product that we 
> found is a 
> board sold by HP (HP SC11Xe) based on a LSI Logic chipset.  
> This is a PCI 
> Express controller with a single U320 parallel SCSI channel.  It is 
> reasonably priced ($200); unfortunately, the documentation on 
> HP's web 
> site states that it will only work with tape devices.  Is 
> anyone familiar 
> with this card who might know if this claim (that the card 
> only works with 
> tape drives) is true or false?
> 

Yes, I have one of those U320 SCSI Parallel PCI Express cards in my
system.
It has a LSI53C1020A A1 down on the hba, which is a single channel.
This hba has a PCI express to pcix bridge, as the 1020A is still PCI X.
This will work with any peripheral device, such as disks devices.
Probably
HP claim to tape is because that is what they certified it with.   I
have it in
a HP ML350, and it works like a champ.  You might want to find out from
HP which systems it works will, b'cuase I found on some other non HP
systems 
it didn't.

Eric Moore
LSI Logic
