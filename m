From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: re :SCSI error handling -- one error blocks the whole SCSI host
Date: Thu, 23 May 2013 21:07:34 +0200
Message-ID: <519E68F6.9090302@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:43398 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab3EWTHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 May 2013 15:07:38 -0400
Received: by mail-bk0-f47.google.com with SMTP id jg1so2060707bkc.34
        for <linux-scsi@vger.kernel.org>; Thu, 23 May 2013 12:07:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Jej B <James.Bottomley@hansenpartnership.com>

> James, am I understanding your suggestion properly?  If so can you
> explain what you meant about the libsas code -- I see that it has its
> own strategy handler but as I said before we've already stopped every
> device attached to the HBA before we ever get there.
> 
> To recapitulate the problem here, we might have a whole fabric
> attached to an HBA via SAS or FC, and be doing 500K IOPS happily to 50
> devices.  Then a single LUN goes wonky and all the IO stops while we
> try to recover that single device, which might take minutes.

I'm not James, but from my experience in pm8001 and libsas, your
understanding is right. and when one error happens on one lun, scsi core
do hold the whole scsi host.

I think Hannes has some good proposal weeks ago, it looks reasonable,
but don't what the status now.


Regards
Jack Wang
