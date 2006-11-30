From: "Kit Gerrits" <kit@gerritsaa.nl>
Subject: SCSI Rescan question
Date: Thu, 30 Nov 2006 12:21:02 +0100
Message-ID: <000001c71471$9fe34480$4c4b3291@kagtqp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:55200 "EHLO
	smtp-out0.tiscali.nl") by vger.kernel.org with ESMTP
	id S1759243AbWK3LVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 06:21:11 -0500
Received: from [82.170.143.51] (helo=redhat01.gerritsacc.nl)
	by smtp-out0.tiscali.nl with esmtp (Tiscali http://www.tiscali.nl)
	id 1GpjyY-0000nO-N4
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 12:21:10 +0100
Received: from kagtqp (b50-11.minvenw.nl [145.50.39.11])
	by redhat01.gerritsacc.nl (Postfix) with ESMTP id 4E64EA7765
	for <linux-scsi@vger.kernel.org>; Thu, 30 Nov 2006 12:25:15 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hey all,

I have replaced a faulty (external) Ultrium tape on a RHEL 2.1 server.
I have read that you can rescan the SCSI bus with:
echo "scsi scan-new-devices" > /proc/scsi/scsi 
( http://kbase.redhat.com/faq/FAQ_46_4011.shtm )

Will this re-set the SCSI bus?
(the system is currently in production and chances are -very slim- that they
will let me do a Cold Reboot)


Thanks,

Kit

