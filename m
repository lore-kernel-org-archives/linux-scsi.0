From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 6 Apr 2007 11:18:53 -0700
Message-ID: <200704061818.l36IIrV7024017@cichlid.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl-63-249-106-23.cruzio.com ([63.249.106.23]:49635 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXDFSYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2007 14:24:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com, cebbert@redhat.com, davem@davemloft.net, dougg@torque.net, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:

> On Fri, 2007-04-06 at 12:32 -0400, Douglas Gilbert wrote:
> > That last line should be:
> >         request_buffer[7] = 10;       /* minimum size per SPC: 18 bytes */
> 
> Er, yes, I'm afraid when I see n-7 I always think n is the lenght, not n
> is the last byte ...

OK. That patch with Doug's fix works in 2.6.21rc6.

Thanks to you all, now I can recrimp my power connector
rats nest and get things back up again.

