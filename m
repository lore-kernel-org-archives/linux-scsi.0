From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ibmvfc: remove unused tag variable
Date: Wed, 03 Dec 2014 08:36:02 -0600
Message-ID: <547F1FD2.3040006@linux.vnet.ibm.com>
References: <1416927010-6036-1-git-send-email-hch@lst.de> <1416927010-6036-2-git-send-email-hch@lst.de> <547F19BB.7010809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42907 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaLCOgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 09:36:41 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 3 Dec 2014 09:36:40 -0500
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 0D0CB6E803C
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2014 09:28:01 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB3Ea4Lo22741058
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2014 14:36:04 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB3Ea4V7028748
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2014 09:36:04 -0500
In-Reply-To: <547F19BB.7010809@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 12/03/2014 08:10 AM, Hannes Reinecke wrote:
> On 11/25/2014 03:50 PM, Christoph Hellwig wrote:
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index f58c6d8..8ac49cf 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -1615,7 +1615,6 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
>>  	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
>>  	struct ibmvfc_cmd *vfc_cmd;
>>  	struct ibmvfc_event *evt;
>> -	u8 tag[2];
>>  	int rc;
>>  
>>  	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
>>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Brian King <brking@linux.vnet.ibm.com>

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


