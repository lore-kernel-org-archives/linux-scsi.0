From: Michael Tokarev <mjt@tls.msk.ru>
Subject: disable TCQ?
Date: Thu, 28 Jun 2007 12:19:33 +0400
Message-ID: <46836F15.2040208@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:20434 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbXF1ITf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jun 2007 04:19:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

/sys/block/sdX/device/queue_depth file is read-write with
libsata, but is read-only with SCSI controllers  (at least
with the ones we have -- mostly aic7xxx or mptsas).

Googling for "disable tcq" gives results about {dis,en}abling
TCQ at boot time, and also mentions ipr (which we don't have).

Is there an option to control TCQ at runtime?

I'm doing a set of (pretty interesting) tests of various
drives and their TCQ/NCQ implementations, everything's
simple on SATA front but I can't test different TCQ modes
with SCSI drives because I can't find a way control TCQ
at runtime, and since those are production machines (I
plug/unplug spare drives for testing, but have no spare
machines), I can't reboot them often.

Thanks.

/mjt
