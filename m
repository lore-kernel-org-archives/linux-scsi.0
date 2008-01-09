From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: AHCI finds disks; no /dev/sd inodes bound?
Date: Wed, 09 Jan 2008 19:50:38 +0100
Message-ID: <4785177E.6060300@s5r6.in-berlin.de>
References: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com> <p738x2zosmd.fsf@bingen.suse.de> <c7bcbd620801090921w1a784417wc8aa42ecb83d589b@mail.gmail.com> <1199899766.3493.20.camel@localhost.localdomain> <20080109174945.GB15346@one.firstfloor.org> <4785138A.4000809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38579 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYAISvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 13:51:39 -0500
In-Reply-To: <4785138A.4000809@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jon Watte <jwatte@gmail.com>, linux-scsi@vger.kernel.org

Stefan Richter wrote:
> The "select SCSI" in libata's Kconfig option is not of great
> help with that issue and is misguided and unnecessary as well.

+comment "Serial and Parallel ATA need SCSI command sets"
+	depends on SCSI=n

 menuconfig ATA
 	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
...
-	select SCSI
+	depends on SCSI
...
-	  NOTE: ATA enables basic SCSI support; *however*,
-	  'SCSI disk support', 'SCSI tape support', or
-	  'SCSI CDROM support' may also be needed,
-	  depending on your hardware configuration.
+	  NOTE: 'SCSI disk support', 'SCSI tape support', or
+	  'SCSI CDROM support' is also required if you have
+	  ATA disks, tapes, or CD/DVD-ROM/R/Ws respectively.
...

-- 
Stefan Richter
-=====-==--- ---= -=--=
http://arcgraph.de/sr/
