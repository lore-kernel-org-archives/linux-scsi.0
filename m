From: <misterbawb@gmail.com>
Subject: Dell 660F needs BLIST_LARGELUN
Date: Thu, 30 Sep 2004 14:26:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <fa7105a5040930112612ae0bf4@mail.gmail.com>
Reply-To: <misterbawb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_75_6534052.1096568771612"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.197]:24369 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S269401AbUI3S0R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 14:26:17 -0400
Received: by mproxy.gmail.com with SMTP id 77so4092392rnk
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2004 11:26:12 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

------=_Part_75_6534052.1096568771612
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a 660F array here with 14 LUNs, and 2.6.8.1 fails to detect any
past the first 8.  Attached is a patch to fix that.

2.4.26 already has the largelun flag for the 660F:
http://linux.bkbits.net:8080/linux-2.4/diffs/drivers/scsi/scsi_scan.c@1.16?nav=index.html|src/|src/drivers|src/drivers/scsi|hist/drivers/scsi/scsi_scan.c

------=_Part_75_6534052.1096568771612
Content-Type: application/octet-stream; name="dell-660F-largelun.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dell-660F-largelun.patch"

LS0tIHNjc2lfZGV2aW5mby5jLm9yaWcJMjAwNC0wOS0zMCAwOToyMDozOC45NjExMjU2ODAgLTA0
MDAKKysrIHNjc2lfZGV2aW5mby5jCTIwMDQtMDktMzAgMDk6MjE6MDAuMTcyOTAxMDAwIC0wNDAw
CkBAIC0xMzIsNyArMTMyLDcgQEAKIAl7IkNPTVBBUSIsICJIU1YxMTAiLCBOVUxMLCBCTElTVF9S
RVBPUlRMVU4yIHwgQkxJU1RfTk9TVEFSVE9OQUREfSwKIAl7IkRETiIsICJTQU4gRGF0YURpcmVj
dG9yIiwgIioiLCBCTElTVF9TUEFSU0VMVU59LAogCXsiREVDIiwgIkhTRzgwIiwgTlVMTCwgQkxJ
U1RfU1BBUlNFTFVOIHwgQkxJU1RfTk9TVEFSVE9OQUREfSwKLQl7IkRFTEwiLCAiUFY2NjBGIiwg
TlVMTCwgQkxJU1RfU1BBUlNFTFVOfSwKKwl7IkRFTEwiLCAiUFY2NjBGIiwgTlVMTCwgQkxJU1Rf
U1BBUlNFTFVOIHwgQkxJU1RfTEFSR0VMVU59LAogCXsiREVMTCIsICJQVjY2MEYgICBQU0VVRE8i
LCBOVUxMLCBCTElTVF9TUEFSU0VMVU59LAogCXsiREVMTCIsICJQU0VVRE8gREVWSUNFIC4iLCBO
VUxMLCBCTElTVF9TUEFSU0VMVU59LAkvKiBEZWxsIFBWIDUzMEYgKi8KIAl7IkRFTEwiLCAiUFY1
MzBGIiwgTlVMTCwgQkxJU1RfU1BBUlNFTFVOfSwK
------=_Part_75_6534052.1096568771612--
