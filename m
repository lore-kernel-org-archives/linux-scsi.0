From: Mark Lord <liml@rtr.ca>
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Date: Thu, 09 Apr 2009 12:57:41 -0400
Message-ID: <49DE2905.3030102@rtr.ca>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk> <49DDF1EB.2060200@rtr.ca> <49DDF744.1090209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:48965 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZDIQ5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Apr 2009 12:57:44 -0400
In-Reply-To: <49DDF744.1090209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Jeff Garzik wrote:
> a single utility should be used to configure a SATA+SAS 
> controller port.  Requiring use of hdparm when the port is in SATA mode, 
> and sg_* when the port is in SAS mode, is a bit annoying.
..

That's why hdparm uses sg_* whenever possible already.

-ml
