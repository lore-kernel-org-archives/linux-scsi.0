From: dougg@torque.net
Subject: Re: PATCH: scsi_debug bug
Date: Tue,  8 Jul 2003 14:00:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1057687201.3f0b06a19b99f@bolt.torque.net>
References: <3F08427C.4050706@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bolt.torque.net ([204.138.244.4]:1955 "EHLO bolt.torque.net")
	by vger.kernel.org with ESMTP id S265074AbTGHRpe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 13:45:34 -0400
In-Reply-To: <3F08427C.4050706@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Quoting Jeff Garzik <jgarzik@pobox.com>:

> No response the first time.  Resending.
> 
> Can someone look at this patch and approve it, please?
> 
> It looks like an obvious bug and fix to me:  MODE_SENSE_10 allocation 
> length LSB is in cdb byte 8, not byte 6.
> 
> This bug is present in both 2.4 and 2.5.

Jeff,
Guilty as charged.

Sorry for the long delay in responding. Hopefully James
and/or Mike Anderson can put the patch in the bk scsi 
repository for the lk 2.5 series.

For the lk 2.4 series, please send a patch to Marcelo 
and cc Alan.

Doug Gilbert
 




-------------------------------------------------
This mail sent through IMP: http://horde.org/imp/
