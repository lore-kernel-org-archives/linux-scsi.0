From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [22/27]
Date: Thu, 17 Feb 2005 15:11:41 -0500
Message-ID: <4214FA7D.1020709@pobox.com>
References: <4214D65B.2030008@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34232 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262333AbVBQUMO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 15:12:14 -0500
In-Reply-To: <4214D65B.2030008@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Comment:  You should use libata for your ATA<->SCSI translation.

Doing so eliminates duplicate code, and ensures that you are compliant 
with the SAT and ATA passthru specifications from T10.

	Jeff



