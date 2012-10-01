From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
Date: Mon, 01 Oct 2012 15:13:01 +0200
Message-ID: <506996DD.30300@redhat.com>
References: <1345471490-17289-1-git-send-email-rjones@redhat.com> <50324439.1000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51262 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2JANNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 09:13:08 -0400
In-Reply-To: <50324439.1000307@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 20/08/2012 16:05, Paolo Bonzini ha scritto:
> Il 20/08/2012 16:04, Richard W.M. Jones ha scritto:
>> From: "Richard W.M. Jones" <rjones@redhat.com>
>>
>> The sg struct is used without being initialized.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=847548
>>
>> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
>> ---
>>  drivers/scsi/virtio_scsi.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> index c7030fb..8a66f83 100644
>> --- a/drivers/scsi/virtio_scsi.c
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>>  	struct scatterlist sg;
>>  	unsigned long flags;
>>  
>> -	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>> +	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>>  
>>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
>>  
>>
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Paolo
> 

Ping, is this patch going into 3.7?

Paolo
