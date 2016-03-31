From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/3] qla2xxx: Remove set-but-not-used variables
Date: Thu, 31 Mar 2016 08:57:26 -0700
Message-ID: <56FD48E6.2050109@sandisk.com>
References: <56FC6049.3090303@sandisk.com> <56FC6076.2030900@sandisk.com>
 <082453e484e89dd27b877373bf51ad0e@suse.de>
 <10CF97DD-4A2C-45A7-9A20-6FA66479C17F@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:48432
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbcCaP5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 11:57:31 -0400
In-Reply-To: <10CF97DD-4A2C-45A7-9A20-6FA66479C17F@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>

On 03/31/16 08:24, Quinn Tran wrote:
>>> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>> index c1461d2..97fcbf2 100644
>>> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
>>> @@ -311,13 +311,6 @@ static void tcm_qla2xxx_free_cmd(struct
>>> qla_tgt_cmd *cmd)
>>>    */
>>>   static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
>>>   {
>>> -	struct qla_tgt_cmd *cmd;
>>> -
>>> -	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) =3D=3D 0) {
>>> -		cmd =3D container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
>>> -		cmd->cmd_flags |=3D BIT_14;
>>> -	}
>>> -
>>>   	return target_put_sess_cmd(se_cmd);
>>>   }
>>
>> Apart from the qla24xx_els_dcmd_iocb() thingy (which has nothing to =
do
>> with your patch)
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> QT: We use the cmd_flags portion for debugging crashes.  It=E2=80=99s=
 our form of tracing. Please do not delete. Thanks.

Hello Quinn,

OK, I will restore that code.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
