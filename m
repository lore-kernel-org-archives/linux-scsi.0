From: David van Hoose <david.vanhoose@comcast.net>
Subject: [RFC] 3rd Party Device Drivers need sd.h
Date: Fri, 17 Oct 2003 16:18:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F904E7F.1070700@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:44464 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S263606AbTJQUSI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 16:18:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have been working on modifying the SATA driver that I got from Promise 
to work under 2.6.0. However, there is a conflict since it needs sd.h. I 
looked and sd.h was merged into sd.c. What reasons were there for doing 
this, and what changes have to be made to 3rd party drivers to 
accomodate it? Please CC to me as I am not on this list.

Thank you,
David van Hoose

