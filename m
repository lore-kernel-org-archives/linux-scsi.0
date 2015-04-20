From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
Date: Mon, 20 Apr 2015 18:08:14 +0530
Message-ID: <193cf54f2b73978a01698fb3fa756e21@mail.gmail.com>
References: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com> <yq11tjvil9g.fsf@sermon.lab.mkp.net>
 <bc4eb5dffe342f41aa5e9dba5afe3d95@mail.gmail.com> <yq17ftf7bko.fsf@sermon.lab.mkp.net>
 <20150414055640.GA29338@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36109 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbbDTMiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 08:38:16 -0400
Received: by qku63 with SMTP id 63so189062808qku.3
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2015 05:38:16 -0700 (PDT)
In-Reply-To: <20150414055640.GA29338@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Tuesday, April 14, 2015 11:27 AM
>To: Martin K. Petersen
>Cc: Sumit Saxena; linux-scsi@vger.kernel.org; thenzl@redhat.com;
>hch@infradead.org; jbottomley@parallels.com; Kashyap Desai
>Subject: Re: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
>
>On Mon, Apr 13, 2015 at 09:17:27PM -0400, Martin K. Petersen wrote:
>> >>>>> "Sumit" == Sumit Saxena <sumit.saxena@avagotech.com> writes:
>>
>> Sumit> Ok, I will spilt this patch in 7 patches. Do you have any
>> Sumit> feedback/comments for other patches of this series? IF you are
>> Sumit> ok with other patches, I will resend the series with patch#1
>> Sumit> splitted in 7 patches and rest of the patches(2,3,4 and 5) will
>> Sumit> remain unchanged.
>>
>> The other patches looked OK on their own. But it's probably best to
>> repost the whole series since you'll need a review from at least one
>> person other than me.
>
>Please also include the sparse fixes I sent you a while ago in the
repost.

I have resent this patch series with sparse fixes sent by you.
