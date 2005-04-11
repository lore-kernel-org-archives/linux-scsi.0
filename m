From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4474] New: ini9100u reports bad geoemtry
Date: Mon, 11 Apr 2005 15:04:24 -0700
Message-ID: <20050411150424.0168829a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:52940 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261944AbVDKWHW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 18:07:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: wagnerric@condor.cxo.cpqcorp.net



Begin forwarded message:

Date: Mon, 11 Apr 2005 14:48:32 -0700
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4474] New: ini9100u reports bad geoemtry


http://bugme.osdl.org/show_bug.cgi?id=4474

           Summary: ini9100u reports bad geoemtry
    Kernel Version: 2.6.10-1.770_FC3 SMP
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: wagnerric@condor.cxo.cpqcorp.net


Distribution:Fedora Core 3

Hardware Environment:
2xPent III/550, initio i9100u SCSI, 120GB WD IDE, 3x145GB Compaq SCSI drives

Software Environment:Fedora Core 3, latest updates via apt, kernel
2.6.10-1.770_FC3 SMP

Problem Description:
Using 3 identical Compaq 145GB SCSI drives with cleared (dd if=/dev/zero
of=/dev/sd?...), run fdisk.  Each drive reports different and unrealistic
geometries (i.e. one says 4 heads, 23 sectors, xxxx cyl.; another says 93 heads,
...).  Tried with adaptec 2944UW, it says 255 heads, 63 sectors for all drives.


Steps to reproduce:
Clear MBR on the SCSI drives.
Use initio i9100u and attempt to fdisk.  Drives report different and
non-standard geometries.
Re-run with adaptec card. All drives report same and sane geoemtries.

I'm not sure if the size of the drive (these are 145GB) factors in.  I was
unable to test with smaller drives.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
