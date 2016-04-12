From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/1] scsi: add Synology DSM 6.0 and higher to 1024 sector
 blacklist
Date: Tue, 12 Apr 2016 14:18:49 -0500
Message-ID: <570D4A19.40000@redhat.com>
References: <20160114003437.354D28EE1D4@bedivere.hansenpartnership.com>
 <570B63B8.6080104@tcnnet.com> <yq1oa9fzhyi.fsf@sermon.lab.mkp.net>
 <570CB1C8.5050106@tcnnet.com> <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021AbcDLTSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 15:18:52 -0400
In-Reply-To: <yq17fg2zn1q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Michel Meyers <steltek@tcnnet.com>
Cc: linux-scsi@vger.kernel.org

On 04/12/2016 01:42 PM, Martin K. Petersen wrote:
>>>>>> "Michel" == Michel Meyers <steltek@tcnnet.com> writes:
> 
>>> Shouldn't we just quirk SYNOLOGY, then?
> 
> Michel> Could be worth it. As far as I can see, they manufacture no
> Michel> directly attached drives (only NAS devices, which I presume are
> Michel> all affected by the same problem as mine).
> 
> Mike: Any preference?
> 

I think quirking SYNOLOGY is best. It will be the safest route and work
for all devices.
