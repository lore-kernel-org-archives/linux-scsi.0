From: Matthew Wilcox <matthew@wil.cx>
Subject: sym2 todo list
Date: Tue, 12 Oct 2004 03:41:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012024148.GD16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54932 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269409AbUJLClt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 22:41:49 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1CHCbl-0005xO-3N
	for linux-scsi@vger.kernel.org; Tue, 12 Oct 2004 03:41:49 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I thought I'd just share my todo list for the sym2 driver.  No particular
commitment or order is implied ;-)

 - Use midlayer tag code (bugzilla #3553)
 - Make messages more consistent
 - More de-BSD-isation
 - Make boot messages less verbose
 - Make DV messages less verbose (bugzilla #2236)
 - Share code with ncr53c8xx where sensible
 - Handle odd-sized transfers (bugzilla #3052)
 - Support VPD in the nvram (depends on PCI VPD code which isn't finished yet)
 - Investigate potential malloc bug (bugzilla #246)
 - Investigate NVRAM byteswapping (bugzilla #2500)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
