From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.24 available
Date: Mon, 14 May 2007 14:57:19 -0400
Message-ID: <4648B10F.6070707@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56682 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXENTBK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 15:01:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: emschwar@debian.org, robbat2@gentoo.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl. Ported to FreeBSD,
Tru64, Solaris, and Windows (cygwin and mingw).

This version adds the sg_raw utility which allows a user to
supply a cdb. Copy of ChangeLog below.

For an overview of sg3_utils and downloads see this page:
http://www.torque.net/sg/sg3_utils.html
The sg_dd utility has its own page at:
http://www.torque.net/sg/sg_dd.html
The SG_IO ioctl is discussed at:
http://www.torque.net/sg/sg_io.html
A full changelog can be found at:
http://www.torque.net/sg/p/sg3_utils.CHANGELOG

A release announcement has been sent to freshmeat.net .

Top of Changelog:
Changelog for sg3_utils-1.24 [20070507]
  - sg_raw: new utility to send arbirary SCSI commands
  - sg_luns: increase number of luns that can be fetched
    - fix length of raw and hex output
    - add '--quiet' option to output only ASCII hex
      representation of each lun
  - sg_rtpg: update for changes in spc4r09
  - sg_persist: update documentation, spc-4 references
    - fix exit status values
  - sg_inq: update version descriptors per spc4r09
    - fix '--id' and '--extended'
    - extend block limits VPD page (sbc3r09)
  - sg_vpd: extend block limits VPD page (sbc3r09)
    - append relative target port identifier to SAS target
      port address with '-iq' option
  - sg_logs: add decoding for stats+performance log pages
    - fix showing of page names for pdt > 0
    - implement '-HH' for single and all pages, fix '-r'
    - when '--maxlen=' given, only do single fetch
    - add Tape Alert (ssc), Media and Element statistics (smc) pages
    - add '--brief' option
  - sg_ses: sync with ses2r16
    - fix bay number for SAS
  - sg_format: add '--dcrt' and '--security' options
  - sgm_dd: add 'smmap' oflag for shared_mmap_io testing
    - add 'dio' oflag
  - sg_dd, sgp_dd: add 'dio' iflag and oflag
  - sg_modes: change SAS mode page names per sas2r09
    - check validity of block descriptors length
  - sg_pt: change opaque context object from 'void *'
    to 'struct sg_pt_base *'
  - sg_opcodes: anticipate extra tmfs from 07-159r0
  - sg_sat_set_features: add more usage information
    - add man page
  - sg_sat_phy_event: add to examples directory
  - sg_lib: sync asc/ascq codes with spc4r10
  - Solaris port: using uscsi interface

Doug Gilbert
