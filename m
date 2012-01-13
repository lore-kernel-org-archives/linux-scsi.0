From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] Copy offload
Date: Fri, 13 Jan 2012 11:35:38 -0800
Message-ID: <CAL1RGDWJjzBnN6Aj_ngvkFco_toe8Dey5QApgmYafpEqECuTSw@mail.gmail.com>
References: <4F0AC112.2000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:42389 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758862Ab2AMTgB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 14:36:01 -0500
Received: by wibhj6 with SMTP id hj6so998945wib.17
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2012 11:35:59 -0800 (PST)
In-Reply-To: <4F0AC112.2000709@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

In general, with my target vendor hat on, I'd be very interested in
what special SCSI commands the Linux initiator stack might want
to use.  Extended copy is one (very complex) case -- and BTW
Microsoft seems to plan on using XCOPY LITE with NTFS.

Another possibly interesting example would be COMPARE AND
WRITE for clustered filesystems.

Any other storage operations that FS developers might want
from the block device?  (Either standard SCSI commands or
more speculative stuff that T10 hasn't thought of yet)

 - R.
