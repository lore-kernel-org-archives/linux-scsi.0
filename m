From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Adding PCI ID tables to aic7xxx and aic79xxx
Date: Tue, 12 Oct 2004 14:27:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C222C.2060800@pobox.com>
References: <416C15E5.7030805@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16803 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266572AbUJLS2J
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 14:28:09 -0400
In-Reply-To: <416C15E5.7030805@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Luben Tuikov wrote:
> Adding proper PCI ID tables to aic7xxx and aic79xx.


ACK, but I wonder if (long term) a follow-up patch to split up the IDs 
into their individual components wouldn't be nice?  That would make the 
driver much more consistent with other Linux PCI drivers.

Regards,

	Jeff


