From: Douglas Gilbert <dougg@torque.net>
Subject: [Announce] smp_utils-0.92 available
Date: Sat, 09 Dec 2006 09:09:58 -0500
Message-ID: <457AC3B6.3090800@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761781AbWLIOKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2006 09:10:08 -0500
Received: from ip-106.82.126.206.dsl-cust.ca.inter.net ([206.126.82.106] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.63 #1 (Red Hat Linux))
	id 1Gt2tz-0001r9-KD
	for linux-scsi@vger.kernel.org; Sat, 09 Dec 2006 14:10:07 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol (SMP). A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with a SSP and
STP initiator). A SAS expander contains a SMP target. Several
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package targets
the linux kernel (lk) 2.6 and lk 2.4 series.

Two interfaces are available: the "mptctl" pass through used
by MPT Fusion SAS HBAs and the "smp_portal" sysfs attribute
pass through used by at least one aic94xx based Linux driver.

For an overview and examples of smp_utils see:
http://www.torque.net/sg/smp_utils.html
A tarball, rpm and deb can be found in table 2.

CHANGELOG (since version 0.91):
  - all: suggest using '-v' if smp_send_req() fails
  - smp_lib: sync function names and results with sas2r07
  - smp_rep_general: sync with sas2r07
  - smp_rep_route_info: add '--multiple' and '--num="
    options. Underlying SMP function may be called multiple
    times to show one line per phy's route table.
  - smp_lib.h: add C++ 'extern "C" ' wrapper
  - smp_discover+smp_discover_list: sync with sas2r07
  - smp_conf_general: add new SMP function
  - smp_utils.8: suggestions for finding expander SAS addresses
    and mptsas ioc_num
  - Makefile.freebsd: builds utilities on FreeBSD
  - man pages: cleanup


Doug Gilbert
