From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 01 Dec 2003 09:22:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070292174.2007.14.camel@mulgrave>
References: <200310231734.10263.krmurthy@cisco.com>
	<03111920183201.15831@naveenb-lnx.cisco.com>
	<20031119144809.A13541@infradead.org>
	<200312011740.09693.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:25092 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262848AbTLAPXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 10:23:39 -0500
In-Reply-To: <200312011740.09693.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Mon, 2003-12-01 at 06:10, Krishna Murthy wrote:
> Hi,
> 	We could use probing code from mid layer provided 
> scsi_scan_host_selected is exported. 
> 
> 	iscsi driver does probe for devices at two places
> a)Once after session establishment.
> b)Whenever an iSCSI async message indicates a change in
> "REPORTED LUNS DATA". (addition/deletion of luns on the target) 

This sounds like an async event which could be handled by the hotplug
system.  Would there be a problem with simply transmitting this to a
user level utility and having it trigger the rescan through the exported
sysfs interfaces?

We could do with a generic infrastructure within SCSI for generating
these events, anyway, if you want to go that route...

James


