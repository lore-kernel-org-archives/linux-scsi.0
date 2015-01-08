From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and
 internal DCMDs
Date: Thu, 8 Jan 2015 16:15:21 +0530
Message-ID: <038e8350b78402d5b2a431138409e8a7@mail.gmail.com>
References: <201501051440.t05EeP9Q030054@palmhbs0.lsi.com> <20150108104043.GB600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:36311 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbbAHKpY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 05:45:24 -0500
Received: by mail-qa0-f45.google.com with SMTP id f12so6665614qad.4
        for <linux-scsi@vger.kernel.org>; Thu, 08 Jan 2015 02:45:23 -0800 (PST)
In-Reply-To: <20150108104043.GB600@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Thursday, January 08, 2015 4:11 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
>hch@infradead.org; jbottomley@parallels.com;
>kashyap.desai@avagotech.com
>Subject: Re: [PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and
>internal DCMDs
>
>Btw, what happend to the plan of using block layer host wide tags?
Those code changes  are going through internal testing. Once it's
completed, I will post the patch to upstream.

Thanks,
Sumit
