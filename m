From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] scsi scan: don't fail scans when host is in recovery
Date: Wed, 22 Feb 2012 14:45:16 -0600
Message-ID: <4F4553DC.7000500@cs.wisc.edu>
References: <1314250598-2852-1-git-send-email-michaelc@cs.wisc.edu> <4F44BBEA.3020400@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43220 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab2BVUpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 15:45:39 -0500
In-Reply-To: <4F44BBEA.3020400@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 02/22/2012 03:56 AM, Hannes Reinecke wrote:
>> ---
>>  include/scsi/scsi_host.h |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index f1f2644..22b7b23 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -791,7 +791,8 @@ static inline struct device *scsi_get_device(struct Scsi_Host *shost)
>>   **/
>>  static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
>>  {
>> -	return shost->shost_state == SHOST_RUNNING;
>> +	return shost->shost_state == SHOST_RUNNING ||
>> +	       shost->shost_state == SHOST_RECOVERY;
>>  }
>>  
>>  extern void scsi_unblock_requests(struct Scsi_Host *);
> 
> James, ping?
> Any reason it was not included?
> 

It is merged in git commit 76e4e12ff2b3ef86773989fd897b194eb38016e6.
