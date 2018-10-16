From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mark expected switch fall-throughs
Date: Mon, 15 Oct 2018 22:47:40 -0400
Message-ID: <yq1murewqsz.fsf@oracle.com>
References: <20181003145535.GA24941@embeddedor.com>
        <yq18t352o9l.fsf@oracle.com>
        <84512689-d898-e670-075d-509bbff20423@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <84512689-d898-e670-075d-509bbff20423@embeddedor.com> (Gustavo
        A. R. Silva's message of "Fri, 12 Oct 2018 14:26:58 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Willem Riede <osst@riede.org>, Kai =?utf-8?Q?M?= =?utf-8?Q?=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, osst-users@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


Gustavo,

>> I'm not entirely convinced that all these identified fall through cases
>> are intentional. From a quick glance, some of them look like bugs...
>
> I took a second look at this and, certainly, the one below looks more like a
> bug. The rest seem to be false positives.

Yep.

>>> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
>>> index bd6ac6b..8e1c45d 100644
>>> --- a/drivers/scsi/ips.c
>>> +++ b/drivers/scsi/ips.c
>>> @@ -3485,6 +3485,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>>>  
>>>  		case START_STOP:
>>>  			scb->scsi_cmd->result = DID_OK << 16;
>>> +			/* fall through */
>
> If you confirm this is an actual bug, I can send a separate fix.

I believe it is. So please do.

-- 
Martin K. Petersen	Oracle Linux Engineering
