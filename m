From: Harald Seipp <SEIPP@de.ibm.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 16:32:51 +0200
Message-ID: <OFDD993463.B29B392A-ONC125705A.004F39C4-C125705A.004FE950@de.ibm.com>
References: <1123768768.5062.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:23429 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751034AbVHKOg1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 10:36:27 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7BEaQOA118970
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 14:36:26 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BEaQo2173308
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 16:36:26 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7BEaQAn027340
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 16:36:26 +0200
In-Reply-To: <1123768768.5062.1.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote on 11.08.2005 15:59:27:
> On Thu, 2005-08-11 at 12:09 +0200, Harald Seipp wrote:
> > I assume this is a bug? How can I prevent that behavior? Can I easily
query
> > if a device on "h b t l" is mounted to work-around?
>
> No, it's expected behaviour.  The mount keeps a reference to the old
> device node so it can't be reused.
Ok - but shouldn't the behavior that devices that have mounted partitions
can be removed be considered as a bug?
Linux 2.4 SCSI Subsystem Howto, proc interface: "....The removal will fail
if the device is busy (e.g. if a file system on the device is mounted)."

Harald Seipp
IBM System and Technology Group

