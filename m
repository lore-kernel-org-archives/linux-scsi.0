From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: kernel 2.6.11.2 / megaraid 2.20.4.5 and /proc question
Date: Sat, 12 Mar 2005 17:50:57 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CC35@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:25225 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261207AbVCLWvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Mar 2005 17:51:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Atul Srinivasan' <atul@sierra-da.com>, linux-scsi@vger.kernel.org

>
>With the 2.6.7 kernel there used to be information in /proc/megaraid.
>I do not see the same information using the 2.6.11.2 kernel.
>Is there anything in /proc using the 2.6.11.2 kernel setup ?
>If not there, then anywhere else ?
>

It is not so much that you had /proc/megaraid in 2.6.7. There are two
distinct series of drivers - megaraid 2.10 and megaraid_mbox 2.20 series.
The 2.10 series are intended to be used on 2.4 kernels and 2.20 on 2.6
kernels. The megaraid_mbox (2.20) driver does not export any /proc
information. You were using 2.00.3 (part of 2.10 series) on 2.6 kernel
which is not really meant to be used that way.

>Also, where might I find information on to forward errors 
>detected bythe
>adapter. e.g send mail to an account
>

I don't fully understand the question. You may want to send a mail to
customer service.

>Thanks,
>Atul
>-

Thanks,
Sreenivas
LSI Logic Corporation
