From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: 5.x branch mainline kernel push in two weeks?
Date: Wed, 20 Apr 2005 13:32:32 -0700
Message-ID: <41EBA11203419D4CA8EB4C6140D8B4010295B3FF@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:55744 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261803AbVDTUcg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 16:32:36 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: open-iscsi@googlegroups.com, linux-iscsi development team <linux-iscsi-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org

So what API are you using for communicating with userspace right now?
How much userspace support do you need?  Is the current iscsi transport
class okay with you and what about the netlink version?
>> the current driver uses ioctls, but I will be looking at what we need
to do to replace that with the ISCSI transport mechanism. 

How much userspace support do you need?  Is the current iscsi transport
class okay with you and what about the netlink version?
>> Good question, I'm still looking into that. Not sure about netlink
version, I don't think the iscsi driver needs it. 

It would be very helpful to have you participating on the various iscsi
transport class and userspace interface discussions.
>> I would be glad to participate in those discussions.  
 

