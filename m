From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 3753] New: multiple definition of
 `ST_partstat'
Date: Tue, 16 Nov 2004 11:19:05 -0800
Message-ID: <20041116111905.0e0de864.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:22915 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262097AbUKPTTT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 14:19:19 -0500
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id iAGJJG909894
	for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 11:19:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Tue, 16 Nov 2004 10:43:01 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 3753] New: multiple definition of `ST_partstat'


http://bugme.osdl.org/show_bug.cgi?id=3753

           Summary: multiple definition of `ST_partstat'
    Kernel Version: 2.6.10-rc2
            Status: NEW
          Severity: blocking
             Owner: andmike@us.ibm.com
         Submitter: selecter@spray.se


Distribution: Debian Sarge

Problem Description:
  LD      drivers/scsi/sd_mod.o
  CC      drivers/scsi/sg.o
  LD      drivers/scsi/built-in.o
drivers/scsi/osst.o(.bss+0x0): multiple definition of `ST_partstat'
drivers/scsi/st.o(.bss+0x0): first defined here
make[2]: *** [drivers/scsi/built-in.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
