From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 13:02:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41472439.4060300@pobox.com>
References: <414711AC.5030200@rtr.ca> <41471A84.4090200@pobox.com> <41471EA9.70806@optonline.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:29321 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269464AbUINRDC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 13:03:02 -0400
In-Reply-To: <41471EA9.70806@optonline.net>
List-Id: linux-scsi@vger.kernel.org
To: Nathan Bryant <nbryant@optonline.net>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Nathan Bryant wrote:
> Jeff Garzik wrote:
> 
>> Linus vetoed future SCSI->ATA translators.  He only allowed libata 
>> because I promised to remove the translation and make it a native 
>> block driver in the future, which I have been working towards.
> 
> 
> Oh, this is incredibly good to hear. It definitely clarifies the path 
> towards implementing new features such as power management...
> 
> Is this written up in a FAQ somewhere?

Not AFAIK.

The basic rule is "don't translate the native protocol into something 
else." and it has been in place for quite a while.

I was allowed a one-time exception for libata, which translates the 
native ATA into SCSI.  The SCSI portions are separated into 
libata-scsi.c so that they may be easily excised or made optional (likely).

	Jeff


