From: "Reilley, Peter" <Peter.Reilley@netapp.com>
Subject: How to map between /dev/sdX and dev/sgX devices?
Date: Thu, 19 Aug 2004 14:35:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <C8CF60CFC4D8A74E9945E32CF096548A022148EC@silver.nane.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.netapp.com ([198.95.226.53]:55747 "EHLO mx01.netapp.com")
	by vger.kernel.org with ESMTP id S267231AbUHSSfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 14:35:18 -0400
Received: from hawk.corp.netapp.com (hawk [10.57.156.122])
	by mx01.netapp.com (8.12.10/8.12.10/NTAP-1.4) with ESMTP id i7JIZGFC024057
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 11:35:16 -0700 (PDT)
Received: from svlexc01.hq.netapp.com (svlexc01.corp.netapp.com [10.57.156.135])
	by hawk.corp.netapp.com (8.12.9/8.12.9/NTAP-1.5) with ESMTP id i7JIZGHv012075
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 11:35:16 -0700 (PDT)
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

What is the correct way to find the corresponding scsi generic
device given the scsi disk node name?   I have a situation
where I must issue SCSI pass thru commands to a specific
/dev/sdX node.   I must find the correct /dev/sgX node is a 
situation where the system may go through a scsi reconfiguration
that would alter the mapping.   This is in a system where there 
could be a hundred scsi devices.

In my case this is related to iscsi but the problem is not
limited to iscsi.   Is there any good way of getting this
mapping.

Thanks,
Pete.
