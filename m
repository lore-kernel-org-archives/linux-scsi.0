From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH] scsi_devinfo: update Hitachi entries
Date: Fri, 26 Jun 2009 20:18:54 -0400
Message-ID: <4A45656E.4050903@redhat.com>
References: <4A2405FD.3000901@redhat.com>	 <1243875275.4203.19.camel@mulgrave.int.hansenpartnership.com>	 <4A241229.5050009@redhat.com> <1243886776.4203.33.camel@mulgrave.int.hansenpartnership.com> <4A26A787.6020903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48584 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZF0ASz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jun 2009 20:18:55 -0400
In-Reply-To: <4A26A787.6020903@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 06/03/09 12:40, Takahiro Yasui wrote:
> http://marc.info/?l=linux-scsi&m=114366299120761&w=2
>> - Blacklist flags are not used to do special handling if needed.
>> - If the device does NOT support the REPORT_LUNS scan, we won't
>>   see any LUN at all, as we don't even look for LUN 1 then.
> 
> In kernel 2.6.16,  sequential_lun_scan() had a argument, lun0_res,
> and lun >=1 was not recognized when lun0 was not attached. Therefore,
> it seems that BLIST_ATTACH_PQ3 was necessary to pretend lun0 exists.
> 
> But if those two are the only reason to be solved, I don't think
> BLIST_ATTACH_PQ3 is necessary for storages which can handle REPORT_LUNS.
> 
> As you mentioned, leaving BLIST_ATTACH_PQ3 in the flag does not change
> the original behaviour, but I hope the BLIST_ATTACH_PQ3 flag is removed
> from OPEN-E so that lun0 is not installed when a storage returns PQ3 as
> other storages.

I will evaluate BLIST_ATTACH_PQ3 flags on our storages, and post
the result here. Please give me some time.

Thanks,
Taka
