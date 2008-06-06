From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 06 Jun 2008 12:56:30 -0400
Message-ID: <yq1ve0mlcxt.fsf@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
	<20080606142613.GA22495@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:28431 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbYFFRBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 13:01:53 -0400
In-Reply-To: <20080606142613.GA22495@shareable.org> (Jamie Lokier's message of "Fri\, 6 Jun 2008 15\:26\:13 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lokier <jamie@shareable.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

>>>>> "Jamie" == Jamie Lokier <jamie@shareable.org> writes:

Jamie> But SSDs present a block device interface, and they still have
Jamie> alignment characteristics for performance.  Even more
Jamie> important, when combining multiple SSDs into a RAID.

I'm not sure whether ATA has a way to get this information like SCSI
dues.  But nothing prevents the SATA driver from setting the
parameters accordingly.

-- 
Martin K. Petersen	Oracle Linux Engineering

