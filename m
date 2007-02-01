From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] sg3_utils-1.23 available
Date: Thu, 01 Feb 2007 08:54:34 -0500
Message-ID: <45C1F11A.3030204@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48924 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422886AbXBANyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2007 08:54:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, emschwar@debian.org, robbat2@gentoo.org, pknirsch@redhat.com, mj@feral.com

sg3_utils is a package of command line utilities for sending
SCSI (and some ATA) commands to devices. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series. In the lk 2.6
series these utilities (except sgp_dd) can be used with any
devices that support the SG_IO ioctl. Ported to FreeBSD,
Tru64 and Windows (cygwin and mingw).

This version adds sg_read_buffer and sg_write_buffer utilities.
Cleans up command line interface of older utilities and all
man pages have been reworked. Package synchronized with SPC-4
revision 8 and SBC-3 revision 8. Copy of ChangeLog below.

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
Changelog for sg3_utils-1.23 [20070131]
  - sg_read_buffer: new utility
  - sg_write_buffer: new utility
  - sg_opcodes, sg_senddiag, sg_logs, sg_modes, sg_start, sg_inq,
    sg_turs, sg_readcap, sg_rbuf: add getopt_long() based cli;
    old and new cli selectable, new getopt_long cli is default
  - scripts: new subdirectory containing some bash scripts
    - add scripts/README file
  - sg_reassign: add '--hex' option for grown and primary lists
  - sg_rtpg: add '--raw' option
  - sg_lib.h, sg_cmds_basic.h + sg_cmds_extra.h: add C++
    'extern "C" ' wrappers
    - cleanup C code so it will compile as C++
  - sg_lib: sync with spc4r08
    - include <inttypes.h>, use PRId64 instead of %lld form
    - fix sg_get_sense_str() when empty sense buffer
  - win32 port: add Makefile.mingw + related support for MinGW
  - sg_cmds_extra: add sg_ll_read_buffer() and sg_ll_write_buffer()
  - sg_dd, sgp_dd, sgm_dd, sg_read: use lseek64() instead of llseek.c
  - sgm_dd: accept coe=<n> for interworking with sg_dd
  - sg_rdac: fix on non-linux ports
  - sg_ses: fix spurious warning in additional element status page
    - '-rr' option outputs a diagnostic page in binary to stdout
  - sg_opcodes: add command timeout descriptor support (spc4r08)
    - change linux specific pass through to generic pass through
  - sg_logs: add 'name=value' decoding for SAS specific lpage
  - examples+utils subdirectories: remove symlinks
  - synchronize man pages with usage messages
  - sg3_utils.spec: rework

Doug Gilbert
