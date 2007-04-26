From: Hari Hara Kumar M <hari@xsigo.com>
Subject: clarifications needed on scsi_scan_target() and some more...
Date: Thu, 26 Apr 2007 09:54:34 -0700
Message-ID: <1177606474.11416.18.camel@hmaharaj-ws.xsigo.com>
Reply-To: hari@xsigo.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat0.xsigo.com ([216.184.48.10]:26229 "HELO main.xsigo.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754848AbXDZQyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Apr 2007 12:54:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

I'm fairly new to the linux scsi landscape and had a couple of questions
on the subsystem api exported to LLDs:

1. How can a host rescan be done after initially calling scsi_scan_host
() ?

2. If scsi_scan_target() is used, can the a ptr to shost_gendev be used
without having to explicitly initialize any of its field other than what
is done by scsi_host_alloc()?

3. If a scsi_remove_device() is done asynchronously in between an abort,
is this acceptable?

4. How can a LLD explicitly set a scsi device state to offline or
online?

Would greatly appreciate any replies or pointers for more documentation.

Thanks in advance!
-Hari
