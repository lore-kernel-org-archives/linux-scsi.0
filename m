From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 12:39:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41471EA9.70806@optonline.net>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.allegientsystems.com ([208.251.178.227]:60420 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S269466AbUINQjG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 12:39:06 -0400
In-Reply-To: <41471A84.4090200@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Jeff Garzik wrote:

> Linus vetoed future SCSI->ATA translators.  He only allowed libata 
> because I promised to remove the translation and make it a native block 
> driver in the future, which I have been working towards.

Oh, this is incredibly good to hear. It definitely clarifies the path 
towards implementing new features such as power management...

Is this written up in a FAQ somewhere?

Nathan
