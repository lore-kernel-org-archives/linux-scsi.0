From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5656] New: system freeze
Date: Thu, 19 Jan 2006 02:26:11 -0800
Message-ID: <20060119022611.321be076.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29596 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161179AbWASK0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2006 05:26:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>



Begin forwarded message:

Date: Thu, 24 Nov 2005 22:22:37 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5656] New: system freeze


http://bugzilla.kernel.org/show_bug.cgi?id=5656

           Summary: system freeze
    Kernel Version: linux 2.6.13-15-default
            Status: NEW
          Severity: blocking
             Owner: andmike@us.ibm.com
         Submitter: collinm@laboiteaprog.com


Most recent kernel where this bug did not occur: 
Distribution:suse 10 
Hardware Environment: 3 hd 
scsi card: 39160 (seem aic7xxx driver) 
hp 18.2 map3367nc (id:00 lun:00) last drive on the cable 
fujitsu map3367nc (id:01:lun:00) 
ibm-esxs map3367np (id:02 lun00) first drive on the cable 
processor: amd 1800+ 
 
 
Software Environment: suse 10, kde 3.4.2 
Problem Description: 
 
i can run the system a lot of time and suddenly the system freeze 
 
often when i boot the system i see: 
 
aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs 
 
target1:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127) 
target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127) 
target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127) 
 
 
(scsi1:A:0:0): Unexpected busfree in Data-in phase 
SEQADDR == 0x84 
SCSI error : <1 0 0 0> return code = 0x10000 
end_request: I/O error, dev sda, sector 8451 
SCSI error : <1 0 0 0> return code = 0x10000 
end_request: I/O error, dev sda, sector 8459 
SCSI error : <1 0 0 0> return code = 0x10000 
end_request: I/O error, dev sda, sector 8467 
SCSI error : <1 0 0 0> return code = 0x10000 
end_request: I/O error, dev sda, sector 8475 
 target1:0:0: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15) 
 
scsi error only happen on dev sda ... (near of the terminaison) 
 
Steps to reproduce:

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
