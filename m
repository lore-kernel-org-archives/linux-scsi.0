From: Boaz Harrosh <bharrosh@panasas.com>
Subject: export bsg.h header to user-mode
Date: Wed, 14 Jan 2009 18:24:54 +0200
Message-ID: <496E11D6.20705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:9882 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763769AbZANQZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jan 2009 11:25:03 -0500
Received: by nf-out-0910.google.com with SMTP id d3so97112nfc.21
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2009 08:24:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi TOMO.

I'm using bsg.ko to submit SG_IO version-4 commands to scsi devices
from user-mode application. (version-4 for use of bidi and varlen).

I have not found a bsg.h header in my fedora-10 distribution. Is
bsg.h exported in kernel-headers-package in latest Kernels? If not
should we, and how to do it?

Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
if I need to fix any thing so it can be compiled from user-mode.

Also do you have a small libbsg or something to make it easier for
use by application? should we maintain such a package?

Pete from the OSC osd project has his set of headers and library
which I used now. Should I clean it up and send it? Or should I just 
keep it as part of the osd project for now? what are the sas and fc
guys using?

Thanks
Boaz
