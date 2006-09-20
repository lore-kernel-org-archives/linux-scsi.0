From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: Multi-Initiator SAS
Date: Tue, 19 Sep 2006 18:43:29 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7032CE7F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42382 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750765AbWITArS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 20:47:18 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@us.ibm.com>

On Tuesday, September 19, 2006 5:55 PM, Douglas Gilbert wrote: 


> This is SATA specific information on phy id 4. So it looks
> like the LSI HBA (0x500062b000002fdc) is holding a "long
> term" affiliation as I have seen with the expander I test
> with. Perhaps Eric could remind me whether the mptsas
> LLD or firmware calls the CLOSE(CLEAR AFFILIATION) link layer
> primitive to end a STP tunnelled ATA command. Anyway the fact
> the 'affiliation valid' is set will lock thet SATA disk
> to that HBA. While there is only one STP initiator (on the
> LSI HBA) there is no contention to worry about.
> 

Primatives are well below driver, as well as transport frames.
All the fusion driver does is pass message frames with SCSI_IO/cdbs.
We have access to config pages that provide info on the topology,
and lets use configure somethings. We have sas_iounit control, that
allows use to reset phys and links.  We have sata and smp passthrus,
other than that, everything is down in firmware.

If you want to know more about the affiliations, we will need
to start an internal discussion with firmware folks. Let me know.

Eric
