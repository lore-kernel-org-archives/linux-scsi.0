From: Christopher Campise <campise@hotpop.com>
Subject: Connecting same device through dual HBAs
Date: Thu, 01 Apr 2004 09:56:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <opr5r84tfarfijrn@smtp.hotpop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from snickers.hotpop.com ([38.113.3.51]:45027 "EHLO
	snickers.hotpop.com") by vger.kernel.org with ESMTP id S262260AbUDAO47
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 09:56:59 -0500
Received: from hotpop.com (kubrick.hotpop.com [38.113.3.103])
	by snickers.hotpop.com (Postfix) with SMTP id 3EFF273C25
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2004 14:19:14 +0000 (UTC)
Received: from ccampise (sw.attotech.com [12.32.232.56])
	by smtp-1.hotpop.com (Postfix) with ESMTP id B83EF1A0168
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2004 14:19:13 +0000 (UTC)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello Everyone-

First time caller here. :)

I'm currently running a Redhat9.0 setup with kernel 2.4.20-8.  I wish to 
connect to a scsi external storage array, that has two interface cards, 
via two Host Bus Adapters on my linux box (in an attempt to increase 
throughput).

I'm using the stock qla2300 drivers and can see both cards when I do a 
'cat /proc/scsi/scsi' but I've only been able to see the array (and it's 
associated LUNs) through one HBA though.  I've done some research and came 
across the multipath concept and being not entirely sure of what it is, 
was wondering if this is the direction I should continue to pursue in 
order to accomplish this?  Or, if not, does anyone have advice as to what 
I need to do to get this to work (if at all possible)?

Thanks in advance!

Chris

