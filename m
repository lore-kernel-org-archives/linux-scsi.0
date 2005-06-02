From: "Kadirvel, Selvi" <selvik@ufl.edu>
Subject: Low I/O performance of PERC 4/DC on PE2650
Date: Thu, 2 Jun 2005 10:01:43 -0400 (EDT)
Message-ID: <1921045012.1117720904051.JavaMail.osg@osgjas02.cns.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sp44en1.nerdc.ufl.edu ([128.227.74.44]:60817 "EHLO smtp.ufl.edu")
	by vger.kernel.org with ESMTP id S261428AbVFBOBy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2005 10:01:54 -0400
Received: from osgjas02.cns.ufl.edu (osgjas02.cns.ufl.edu [128.227.74.132])
	by smtp.ufl.edu (8.13.1/8.13.1/2.5.0) with ESMTP id j52E1iT8082484
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 10:01:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 We use a PERC 4/DC card on a PowerEdge 2650 server. Connected to 
each SCSI bus is a set of 14 physical disks. Using the Dell 
Manager utility we create RAID 0 (logical) disk with 4-way stripes 
i.e 4 physical disks(across the two channels) and 128K block size. 
Using I/O benchmark applications like IOzone, the maximum 
throughput obtained is only about 100 MBps. We get lower values 
for other stripe sizes and block sizes. Shouldn't this be higher, 
considering that the SCSI bus provides 320 MBps throughput ? Does 
anyone know how to get better performance?

 Thanks.
 -Selvi


