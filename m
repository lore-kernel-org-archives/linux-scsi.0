From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.12 released
Date: Fri, 21 Jan 2005 18:00:43 +1000
Message-ID: <41F0B6AB.4020900@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:47785 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261523AbVAUIAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jan 2005 03:00:37 -0500
Received: from localhost (localhost [127.0.0.1])
	by borg.st.net.au (Postfix) with ESMTP id 1E4B8394576
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2005 18:00:35 +1000 (EST)
Received: from [192.168.48.80] (dsl-234.128.240.220.lns02-wick-bne.dsl.comindico.com.au [220.240.128.234])
	by borg.st.net.au (Postfix) with ESMTP id CC7EA39451D
	for <linux-scsi@vger.kernel.org>; Fri, 21 Jan 2005 18:00:33 +1000 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball, rpm and deb can be found on http://www.torque.net/sg .
Overview of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement has been sent to freshmeat.net .

Changelog for sg3_utils-1.12 [20050121]
   - sg_wr_mode: new utility to modify (i.e. write to) mode pages
   - sg_reassign: new utility: issues Reassign Blocks command
   - sg_rtpg: new utility: issues Report Target Port Groups command
              [Christophe Varoqui]
   - ATA IDENTIFY command misspelt as "IDENTITY" in several places
   - sginfo: tweak SAS mode pages to match sas 1.1 rev 07
         - add NV_DIS bit to disk caching mode page
   - sg_map: open /dev/nst* rather than /dev/st* (to stop
             spurious rewinds)
   - sg_lib: ATA return sense descriptor
         - add sg_get_sense_info_fld() to fetch info field from
           sense data
         - fix bug in sg_scsi_sense_desc_find()
         - add sense key specific decoding for fixed format sense data
   - sg_modes: extend '-p' option to allow
               '-p=<page_code>,<subpage_code>'
         - add '-A' option to output all mode pages and subpages
         - extend '-l' option to show subpages, selected command
           set pages
   - sg_inq: fix LUN WWN output in unit path report VPD page (emc)
             [Hergen Lange]
   - sg_get_config: some additions for DVD-R dual layer
   - sg_modes: show write protect (WP) and DpoFua flags for disks
   - sg_cmds: add llbaa argument to sg_ll_mode_sense10()


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
LOG SELECT          sg_logs('-r')
LOG SENSE           sg_logs
MODE SELECT(6)      sg_wr_mode, sginfo, sg_emc_trespass
MODE SELECT(10)     sg_wr_mode, sginfo, sg_emc_trespass
MODE SENSE(6)       sg_modes, sg_wr_mode, sginfo, sg_senddiag('-e')
MODE SENSE(10)      sg_modes, sg_wr_mode, sginfo, sg_senddiag('-e')
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
REASSIGN BLOCKS     sg_reassign
RECEIVE DIAGNOSTIC  sg_senddiag, sg_ses
REPORT LUNS         sg_luns
REPORT SUPPORTED OPERATION CODES              sg_opcodes
REPORT SUPPORTED TASK MANAGEMENT FUNCTIONS    sg_opcodes
REPORT TARGET PORT GROUPS       sg_rtpg
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
IDENTIFY            sg_inq, sg_scan


Doug Gilbert


