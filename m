From: Jeff Layton <jtlayton@poochiereds.net>
Subject: Qlogic ISP 1020
Date: Mon, 22 Mar 2004 20:19:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080004793.5848.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rdu26-93-067.nc.rr.com ([66.26.93.67]:46490 "EHLO
	salusa.poochiereds.net") by vger.kernel.org with ESMTP
	id S261807AbUCWBT7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 20:19:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by salusa.poochiereds.net (Postfix) with ESMTP id 28D12BF3C
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2004 20:19:58 -0500 (EST)
Received: from salusa.poochiereds.net ([127.0.0.1])
	by localhost (salusa [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 20769-09 for <linux-scsi@vger.kernel.org>;
	Mon, 22 Mar 2004 20:19:55 -0500 (EST)
Received: from tleilax.ix.dyndns.org (tleilax.ix.dyndns.org [192.168.1.3])
	by salusa.poochiereds.net (Postfix) with ESMTP id EB0AABF3A
	for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2004 20:19:54 -0500 (EST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recently acquired a new tape drive with a HVD SCSI interface. I also
got a QLogic ISP 1020 based SCSI card to drive it. Unfortunately, I seem
to be having some problems with the qlogicisp driver in the 2.6 kernel.
Occasionally I get a SCSI error, and it takes the tape drive offline,
since the qlogicisp driver doesn't have proper error handling for 2.6.

Is there a maintainer for the 2.6 qlogicisp driver? I saw that Christoph
Hellwig had posted part of a patch to add support for the 1020 and 1040
cards to the qla1280 driver. Has this been completed yet, and if so is
there a place I could download the complete patch? 
If not, I'd be happy to help test patches for this, as my tape setup is
more or less useless to me until I have a driver that has proper error
handling.

Alternately, if anyone knows of a working driver for the QLA1020 for a
2.6 kernel, I'd appreciate any pointers.

Thanks,
-- 
Jeff Layton <jtlayton@poochiereds.net>


