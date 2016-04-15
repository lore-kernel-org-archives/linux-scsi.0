From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Fri, 15 Apr 2016 15:27:46 +0530
Message-ID: <649a6feca5fbc7e60aafd7d5e59e1edc@mail.gmail.com>
References: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
	<1459536717.30035.113.camel@localhost.localdomain>	<56FEC864.5050008@stratus.com>
	<1459541058.30035.126.camel@localhost.localdomain>	<38b26e94d10098596fb11cf9bafcb7c0@mail.gmail.com>
	<c762138f15c771759b451b16d97f199e@mail.gmail.com>	<570B93C9.3040102@stratus.com>
 <yq1r3e7sibv.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.161.176]:34977 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcDOJ5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 05:57:48 -0400
Received: by mail-yw0-f176.google.com with SMTP id i84so131118043ywc.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 02:57:47 -0700 (PDT)
In-Reply-To: <yq1r3e7sibv.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Lawrence <joe.lawrence@stratus.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, emilne@redhat.com, linux-scsi@vger.kernel.org, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>

Joe ,
 The below mentioned patch is an older patch, verified latest code also
the code before merging(mpt2sas & mpt3sas) didn't find changes of below
patch. So I am searching for the patch which has removed the
functionality/changes of the below patch.

I shall get back to you on this by Monday.

Thanks,
 Chaitra

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Friday, April 15, 2016 8:13 AM
To: Joe Lawrence
Cc: Chaitra Basappa; Sathya Prakash Veerichetty; emilne@redhat.com;
linux-scsi@vger.kernel.org; Suganath Prabu Subramani; Calvin Owens
Subject: Re: [PATCH] mpt3sas - remove unused fw_event_work delayed_work

>>>>> "Joe" == Joe Lawrence <joe.lawrence@stratus.com> writes:

Joe> Do we know why f1c35e6aea579 "mpt2sas: RESCAN Barrier work is added
Joe> in case of HBA reset" was unneeded for the mpt3 version?  If that
Joe> is interesting, that info could be added to v2 commit message as
Joe> well.

Chaitra?

-- 
Martin K. Petersen	Oracle Linux Engineering
