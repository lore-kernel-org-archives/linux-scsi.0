From: "Penchala Narasimha Reddy Chilakala, ERS-HCLTech"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 17 Nov 2009 10:57:01 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E91552CDE@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <1258386668.2517.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:51019 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZKQF1F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 00:27:05 -0500
In-Reply-To: <1258386668.2517.7.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi James,

Please ignore the previous mail and the attached patch in that mail.

Thanks,
Narasimha Reddy

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de]
Sent: Monday, November 16, 2009 9:21 PM
To: Penchala Narasimha Reddy Chilakala, ERS-HCLTech
Cc: 'linux-scsi@vger.kernel.org'; James Bottomley; ServeRAID Driver
Subject: RE: [PATCH ] scsi-misc-2.6: File System going into read-only mode

On Mon, 2009-11-16 at 08:55 +0530, Penchala Narasimha Reddy Chilakala,
ERS-HCLTech wrote:
> Hi James,
>
> Thanks a lot for your nice review, feedback and support so far. I hope
> that we have sorted out all the issues raised by you except the racy
> issue.

Yes ... I think the race problem isn't particularly relevant to the
bugs, so send me a patch without the attempted ioctl fib counting and it
can go into -rc ... you can work on the fib counting later for
scsi-misc.

James



DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
