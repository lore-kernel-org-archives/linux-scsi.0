From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 00/11] megaraid_sas: Updates for scsi-next
Date: Fri, 23 Dec 2016 17:32:53 +0100
Message-ID: <515ba98f-961b-3143-b7c5-959f081f3bb0@redhat.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
 <02164bad-0f41-92f3-1fdb-bffc75abbf85@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761496AbcLWQlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Dec 2016 11:41:18 -0500
In-Reply-To: <02164bad-0f41-92f3-1fdb-bffc75abbf85@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com

On 23.12.2016 16:24, Tomas Henzl wrote:
> On 23.12.2016 02:19, Sasikumar Chandrasekaran wrote:
>> Sasikumar Chandrasekaran (11):
>>   megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid
>>     Controllers
>>   megaraid_sas: 128 MSIX Support
>>   megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid
>>     Controllers
>>   megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and
>>     IO Coalescing
>>   megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID
>>     1/10 Writes
>>   megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid
>>     Controllers
>>   megaraid_sas: Add the Support for SAS3.5 Generic Megaraid Controllers
>>     Capabilities
>>   megaraid_sas: Enable or Disable Fast path based on the PCI Threshold
>>     Bandwidth
>>   megaraid_sas: ldio_outstanding variable is not decremented in
>>     completion path
>>   megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid
>>     Controllers
>>   megaraid_sas: driver version upgrade
>>
>>  drivers/scsi/megaraid/megaraid_sas.h        | 139 ++++--
>>  drivers/scsi/megaraid/megaraid_sas_base.c   | 240 +++++++--
>>  drivers/scsi/megaraid/megaraid_sas_fp.c     | 341 +++++++++++--
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 750 +++++++++++++++++++++++-----
>>  drivers/scsi/megaraid/megaraid_sas_fusion.h | 364 ++++++++++++--
>>  5 files changed, 1557 insertions(+), 277 deletions(-)
>>
> I finished review of this set and ack-ed it.
> There still is a large amount (~1600) of checkpatch errors,
> ERROR: DOS line endings
> ERROR: trailing whitespace
> ...
> I complained about this several times and was hoping that Sasi would fix all that in V6
> but for some reason it hasn't been fixed.
> I don't want to stop the series only because of formatting issues,
> so well ok
> -tm

I looked into this once again and I think now, that the issue 
with the 'line endings' is an issue on my side. 
I'm sorry for that and please ignore my previous comment.
-tm

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


