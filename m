From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH Repost 0/2] Block I/O while SG reset operation in progress
Date: Wed, 08 Mar 2006 14:49:47 -0500
Message-ID: <1141847387.28879.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65012 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932189AbWCHTt6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Mar 2006 14:49:58 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k28Jntrf005019
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 11:49:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Following the discussion with Mike Anderson on the original patch:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114081263725777&w=2
and
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080001928462&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080001916527&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=114080002012180&w=2

I've implemented the missing item of waking up those waiting for
recovery to complete as well as restarting queues that may have
been stopped.

In conversations with Mike, it's agreed that this patch is sufficient
to block i/o while performing resets via SG - the original immediate goal.
However, we've noted several other issues in this interface that will
need to be addressed eventually.

-- james s


