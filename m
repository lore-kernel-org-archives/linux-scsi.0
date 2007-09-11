From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Tue, 11 Sep 2007 20:50:27 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B4011680E8@G3W0634.americas.hpqcorp.net>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:52604 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbXIKUxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 16:53:25 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>


Boaz Harrosh wrote:

> Here are more accessors patches. I have tried
> to find Maintainers of drivers but please help me if
> I missed any.

The cciss tape drive code probably needs updating.

It's in drivers/block/cciss_scsi.c

-- steve











