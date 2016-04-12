From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 03/14] libsas: Define ATA_CMD_NCQ_NON_DATA
Date: Tue, 12 Apr 2016 12:25:46 +0200
Message-ID: <570CCD2A.6000806@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
 <1460443678-57934-4-git-send-email-hare@suse.de>
 <570CC7F6.1020607@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <570CC7F6.1020607@huawei.com>
Sender: linux-ide-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On 04/12/2016 12:03 PM, John Garry wrote:
> On 12/04/2016 07:47, Hannes Reinecke wrote:
>> Define the NCQ NON DATA command and update libsas to handle it
>> correctly.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>>   drivers/scsi/isci/request.c            | 3 ++-
>>   drivers/scsi/libsas/sas_ata.c          | 3 ++-
>>   drivers/scsi/mvsas/mv_sas.c            | 3 ++-
>>   drivers/scsi/pm8001/pm8001_sas.c       | 3 ++-
>>   include/linux/ata.h                    | 1 +
>>   include/trace/events/libata.h          | 1 +
>>   7 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> index fc2e767..ebaf5ab 100644
>> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
>> @@ -1575,6 +1575,7 @@ static u8 get_ata_protocol(u8 cmd, int
>> direction)
>>       case ATA_CMD_FPDMA_READ:
>>       case ATA_CMD_FPMDA_RECV:
>>       case ATA_CMD_FPDMA_SEND:
>> +    case ATA_CMD_NCQ_NON_DATA:
>>       return SATA_PROTOCOL_FPDMA;
>>
>=20
> I'm going to double-check this. It may correspond to
> SATA_PROTOCOL_NONDATA, and not SATA_PROTOCOL_FPDMA.
>=20
Thanks. The spec is not exactly clear in that regard...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
