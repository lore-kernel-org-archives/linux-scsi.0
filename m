From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: Patch
Date: Mon, 3 Nov 2003 14:45:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA201DF578@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.203.33.17] ([65.203.33.17]:40937 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S262782AbTKCWps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2003 17:45:48 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: David Lethe <David_Lethe@us.xyratex.com>, Bill Krempp <Bill_Krempp@us.xyratex.com>

Hi,

I work for a Xyratex International.  We are currently manufacturing a
FC-SATA RAID subsystem called Kashi-II.  We sell only to OEMs, hence we
have run into a problem involving scsi_scan.c and the "device_list[]".
We need to set the BLIST_SPARSELUN flag to support non-contiguous lun
numbering.  Because we sell only to OEMs, the Vendor ID will change.
The logic in scsi_scan.c will not handle a wild card or "NULL" for the
Vendor ID.  Can we 
add code to allow a wildcard for this?  The Model "Kashi-II" will remain
constant across all OEMs.  If we cannot do this, each OEM will have to
submit an entry to this list for 2.4.x support.

Thanks in advance for your time!    

Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 

