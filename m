From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: BUG 2.6.24-rc4-mm1 -- Boot still hangs w/ async scsi scan
Date: Wed, 05 Dec 2007 11:36:39 -0500
Message-ID: <1196872599.5346.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:24867 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXLEQrD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 11:47:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@steeleye.com, Eric.Moore@lsi.com

As reported here:

	http://marc.info/?l=linux-scsi&m=119645761124683&w=4

against 24-rc3-mm2, I'm still seeing the hang on my HP ia64 NUMA
platform under 24-rc4-mm1 with async scsi scan enabled.  I'm still
seeing the message  "mptspi: ioc#: mpt_config failed" when it hangs. 

I can boot by disabling async scan.  However, I've also noticed some
disks attached via one of the "mpt" adapters ["scsi8" in console long in
message linked above] going "off-line" during stress tests.  This was
under 24-rc3-mm2.  Haven't got that far yet with 24-rc4-mm1.

Regards,
Lee


