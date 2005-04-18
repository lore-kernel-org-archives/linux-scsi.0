From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] sdparm 0.90
Date: Mon, 18 Apr 2005 13:42:33 -0400
Message-ID: <4263F189.3000700@pobox.com>
References: <4263B56B.2010905@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:1951 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262141AbVDRRms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 13:42:48 -0400
In-Reply-To: <4263B56B.2010905@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> sdparm is a new command line utility designed to get and set
> SCSI disk parameters (cf hdparm for ATA disks). More generally
> it gets and sets mode page information on SCSI devices or devices
> that use a SCSI command set (e.g. CD/DVD drives (any transport)
> and SCSI tape drives).

I'm biased, but I would prefer to use blktool for this sort of thing...

	Jeff



