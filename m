From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Disk Errors
Date: Tue, 1 Feb 2005 13:24:43 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BB5232F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:53689 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261281AbVBASZJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Feb 2005 13:25:09 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>, dougg@torque.net
Cc: Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

An unrecoverable medium error is typically `corrected' when a write to
the block occurs. RAID cards will use the redundancy to calculate the
data and write it back to the offending drive for instance.

Otherwise, for none-redundant stores, bad media is as good as anything
to remind one that the data is gone ;->

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bryan Henderson
Sent: Tuesday, February 01, 2005 1:01 PM
To: dougg@torque.net
Cc: Kit Gerrits; linux-scsi@vger.kernel.org
Subject: Re: Disk Errors

>So there are two situations in which damaged blocks remain
>accessible:
>    1) unrecoverable medium errors
> ...

What's the rationale behind leaving a damaged block accessible in the
case 
of an unrecoverable medium error?  A possibility that someone might 
actually be able to recover the data?
