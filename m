From: Russell Lewis <spamhole-2001-07-16@deming-os.org>
Subject: scsi_do_req documentation?
Date: Mon, 19 Aug 2002 15:19:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D616EF2.3060905@deming-os.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deming-os.org (bi01p1.co.us.ibm.com [32.97.110.142])
	by deming-os.org (8.11.6/8.11.6) with ESMTP id g7JMjbh23192
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2002 15:45:37 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can somebody give me a link to good documentation of scsi_do_req?  I'm 
looking especially for details on how my done function will be called 
(interrupt context or not?) and who's responsible for cleaning up the 
Scsi_Cmnd structure.

