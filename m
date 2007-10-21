From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.25 available
Date: Sun, 21 Oct 2007 13:07:24 +0200
Message-ID: <471B32EC.3040404@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbXJULHd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Oct 2007 07:07:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: emschwar@debian.org, "Robin H. Johnson" <robbat2@gentoo.org>

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl. Ported to FreeBSD,
Tru64, Solaris, and Windows (cygwin and mingw).

This version adds three new utilities: sg_sat_set_features, sg_stpg
and sg_safte. The sg_dd utility now has a sparse write capability.
Various utilities have been updated to reflect changes in t10.org
drafts. The build infrastructure has been changed to use autotools
rather than hand-crafted Makefiles. Copy of ChangeLog below.

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
Changelog for sg3_utils-1.25 [20071016]
  - sg_stpg: new utility to Set Target Port Groups
  - sg_safte: new utility to query SAF-TE processor (SES like)
  - sg_sat_set_features: new utility (actually copied from examples
    directory); renamed examples version to: sg__sat_set_features
  - sg_read_buffer: restore (had fallen out of build scripts)
  - sg_dd: add oflag=sparse to step over bs*bpt number of zeros;
    - with oflag=sparse, write last bs*bpt segment at end or after
      error so file length of OFILE is appropriate
    - when coe>1 then SCSI READ LONG logic remembers extended block
      length of first encountered error
  - sg_dd, sgm_dd, sgp_dd: allow iflag=null and oflag=null both of
    which do nothing (placeholders)
  - sg_ses: sync with ses2r17 then r18
  - sg_vpd, sg_inq: add block device characteristics VPD page
  - sg_inq: add '--vpd' option (or '-e') for backward compatibility
  - sg_vpd: decode protocol specific lu information page for SAS
    - add more RDAC vendor VPD pages
  - sg_logs: update background scan results log page, sbc3r11
    - add generation code to protocol specific page for SAS SSP
    - add media changer diagnostic data log page
  - sg_raw: fix error message when do_scsi_pt() fails
  - sg_lib: sync asc/ascq codes with spc4r11
    - add sg_get_num_nomult()
    - add TPROTO_* protocol identifier constants to sg_lib.h
  - sg_cmds_extra: add sg_ll_set_tgt_prt_grp()
  - place source in subversion repository
  - split code into src/ lib/ and include/ directories
  - sync debian directory with their 1.24 version (sid unstable)
  - convert build logic to use autotools (i.e. './configure ; make')
    - rename this file from CHANGELOG to ChangeLog
    - note: only code in lib/ and src/ directories built by
      autotools; some other subdirectories still use hand-crafted
      Makefiles


Doug Gilbert
