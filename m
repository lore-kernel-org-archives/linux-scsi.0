From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: Always try to read VPD pages
Date: Wed, 19 Apr 2017 16:57:54 +0200
Message-ID: <b17265f8-60f7-ed39-94b0-016b75e577ee@redhat.com>
References: <20170413021300.25023-1-david@gibson.dropbear.id.au>
 <20170413133909.GC13387@stefanha-x1.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170413133909.GC13387@stefanha-x1.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Hajnoczi <stefanha@redhat.com>, David Gibson <david@gibson.dropbear.id.au>
Cc: famz@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 13/04/2017 15:39, Stefan Hajnoczi wrote:
> On Thu, Apr 13, 2017 at 12:13:00PM +1000, David Gibson wrote:
>> @@ -705,6 +706,28 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
>>  	return virtscsi_tmf(vscsi, cmd);
>>  }
>>  
>> +static int virtscsi_device_alloc(struct scsi_device *sdevice)
>> +{
>> +	/*
>> +	 * Passed through SCSI targets (e.g. with qemu's 'scsi-block')
>> +	 * may have transfer limits which come from the host SCSI
>> +	 * controller something on the host side other than the target
> 
> s/controller something/controller or something/ ?

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

with this change.

Paolo
