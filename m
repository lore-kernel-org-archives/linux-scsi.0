From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.11 released
Date: Mon, 29 Nov 2004 21:41:31 +1000
Message-ID: <41AB0AEB.4020404@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:45770 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261687AbUK2Lli (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 06:41:38 -0500
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 935623944EE
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 21:41:35 +1000 (EST)
Received: from [192.168.48.80] (dsl-40.129.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.129.40])
	by borg.st.net.au (Postfix) with ESMTP id 39BF03944A4
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 21:41:33 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball, rpm and deb can be found on http://www.torque.net/sg .
Overview of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement has been sent to freshmeat.net .

Changelog for sg3_utils-1.11 [20041126]
   - sg_sync: new utility: invokes the synchronize cache command
   - sg_prevent: new utility: invokes the prevent allow medium
     removal command
   - sg_get_config: new utility: get configuration command for
     dvds and cds
   - sg_request: fix, allocation length wasn't set
   - sg_start: remove '-s', as start_stop_unit implicitly syncs caches
   - sg_ses: add SAS expander element type
   - sg_inq: add sanity check to unit serial number (VPD page 0x80)
         - output ANSI version string (e.g. "SPC-2", previously
	  was a number)
         - add '-s' option to decode SCSI Ports VPD page
   - sg_logs: decoding of format status and non-volatile cache log
         pages (0x8 and 0x17 in sbc-2)
   - sg_dd: handle compile error when O_DIRECT not defined
   - sginfo: tighten sanity checks around Unit serial number VPD page


Here is the contents of the COVERAGE file found in the tarball:

                         Command coverage
                         ================
The following table lists SCSI commands in alphabetical order on the
left and the sg3_utils utilities that implement invocations of them
on the right. The second table lists supported ATA commands.

SCSI command        sg3_utils utilities that use this SCSI command
------------        ----------------------------------------------
GET CONFIGURATION   sg_get_config
INQUIRY             sg_inq, sginfo, sg_logs, sg_map('-i'), sg_modes,
                     sg_opcodes, sg_persist, sg_scan, sg_ses
LOG SELECT          sg_logs
LOG SENSE           sg_logs
MODE SELECT(6)      sginfo, sg_emc_trespass
MODE SELECT(10)     sginfo, sg_emc_trespass
MODE SENSE(6)       sginfo, sg_modes, sg_senddiag('-e')
MODE SENSE(10)      sginfo, sg_modes, sg_senddiag('-e')
PERSISTENT IN       sg_persist
PERSISTENT OUT      sg_persist
PREVENT ALLOW MEDIUM REMOVAL            sg_prevent
READ(6)             sg_dd, sgm_dd, sgp_dd, sg_read
READ(10)            sg_dd, sgm_dd, sgp_dd, sg_read
READ(12)            sg_dd, sgm_dd, sgp_dd, sg_read
READ(16)            sg_dd, sgm_dd, sgp_dd, sg_read
READ BUFFER         sg_rbuf, sg_test_rwbuf
READ CAPACITY(10)   sg_readcap, sg_dd, sgm_dd, sgp_dd
READ CAPACITY(16)   sg_readcap, sg_dd, sgm_dd, sgp_dd
READ DEFECT(10)     sginfo
READ DEFECT(12)     sginfo
READ LONG           sg_read_long
RECEIVE DIAGNOSTIC  sg_senddiag, sg_ses
REPORT LUNS         sg_luns
REPORT SUPPORTED OPERATION CODES              sg_opcodes
REPORT SUPPORTED TASK MANAGEMENT FUNCTIONS    sg_opcodes
REQUEST SENSE       sg_requests
SEND DIAGNOSTIC     sg_senddiag, sg_ses
START STOP          sg_start
SYNCHRONIZE CACHE   sg_sync, sg_dd, sgm_dd, sgp_dd
TEST UNIT READY     sg_turs
VERIFY(10)          sg_verify
WRITE(6)            sg_dd, sgm_dd, sgp_dd
WRITE(10)           sg_dd, sgm_dd, sgp_dd
WRITE(12)           sg_dd, sgm_dd, sgp_dd
WRITE(16)           sg_dd, sgm_dd, sgp_dd
WRITE BUFFER        sg_test_rwbuf
WRITE LONG          sg_write_long


ATA command         sg3_utils utilities that use this SCSI command
-----------         ----------------------------------------------
IDENTITY            sg_inq, sg_scan


Doug Gilbert
