From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 03/17] target/sbc: Add DIF setup in sbc_check_prot
 + sbc_parse_cdb
Date: Wed, 22 Jan 2014 20:00:49 +0200
Message-ID: <52E00751.5010309@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>	 <1390099480-29013-4-git-send-email-nab@daterainc.com>	 <52DBBA69.4040800@dev.mellanox.co.il> <1390344494.5567.792.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390344494.5567.792.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/22/2014 12:48 AM, Nicholas A. Bellinger wrote:
> +	cmd->prot_handover = PROT_SEPERATED;
>> I know that we are not planning to support interleaved mode at the
>> moment, But I think
>> that the protection handover type is the backstore preference and should
>> be taken from se_dev.
>> But it is not that important for now...
>>
> Yeah, I figured since the RDMA pieces needed the handover type defined
> in some form, it made sense to include PROT_SEPERATED hardcoded here,
> but stopped short of adding se_dev->prot_handler for the first round
> merge.
>
> --nab
>

Actually they don't, I just added them in iSER code to demonstrate the 
HW ability.
If we are not planning to support that (although as MKP mentioned it 
might be useful in some cases),
you can remove that for now and we can add it in the future - iSER can 
ignore it for now (I'll refactor the patches).

Sagi.
