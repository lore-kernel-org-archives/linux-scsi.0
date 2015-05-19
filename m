From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 4/18] megaraid_sas : Move controller's queue depth
 calculation in adapter specific function
Date: Tue, 19 May 2015 13:02:45 +0530
Message-ID: <6841cb68423ad31a6e7e7068af7a658f@mail.gmail.com>
References: <201504231103.t3NB3Ajm029643@palmhbs0.lsi.com> <1432016547.4337.61.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:33471 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbbESHcr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2015 03:32:47 -0400
Received: by qgde91 with SMTP id e91so3023777qgd.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2015 00:32:46 -0700 (PDT)
In-Reply-To: <1432016547.4337.61.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
>Sent: Tuesday, May 19, 2015 11:52 AM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>kashyap.desai@avagotech.com
>Subject: Re: [PATCH v3 4/18] megaraid_sas : Move controller's queue depth
>calculation in adapter specific function
>
>On Thu, 2015-04-23 at 16:30 +0530, Sumit.Saxena@avagotech.com wrote:
>> This patch will move internal commands and SCSI commands reservation
>> in adapter's sepcific functions.
>
>Commit messages like this aren't useful.  It's just the subject with "This
>patch
>will" added.  The ideal is that you describe what's going on at greater
>length in
>the commit message.  However, if the subject says it all, just leave the
>message blank rather than repeating the subject (and making me excise it
>again).

I will take care of  this in future.

Thanks
Sumit
>
>James
>
