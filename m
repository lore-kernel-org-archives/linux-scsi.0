From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Wed, 22 Apr 2015 17:34:54 +0530
Message-ID: <cfd2b3abaeaf5e0d9ec62ef3cfb9b27a@mail.gmail.com>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com> <20150421104210.GC8920@infradead.org>
 <3224b33c001a84f19fc033e0d55422a1@mail.gmail.com> <20150422114002.GA19903@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33150 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbbDVME4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2015 08:04:56 -0400
Received: by qgdy78 with SMTP id y78so81921552qgd.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2015 05:04:55 -0700 (PDT)
In-Reply-To: <20150422114002.GA19903@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Wednesday, April 22, 2015 5:10 PM
>To: Sumit Saxena
>Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; jbottomley@parallels.com; Kashyap Desai
>Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag
support
>for internal command indexing
>
>On Wed, Apr 22, 2015 at 05:02:03PM +0530, Sumit Saxena wrote:
>> Christoph,
>> I have started rework for the patches. I will remove debug printks.
>> Can you please let me know should I go for separate patch for change
>> in calling convention return_cmd?
>
>If it makes a huge difference for you feel free to keep it as-is and
document
>the rationale for it in the changelog.
Ok, I will create single patch and update the rationale for it in
changelog.
