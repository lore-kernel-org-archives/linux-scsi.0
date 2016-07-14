From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH 1/1] scsi: ufs: tc-dwc-g210 driver fix for 20-bit RMMI
Date: Thu, 14 Jul 2016 10:34:54 +0100
Message-ID: <f43c4fad-ae1c-9b50-45f2-a91d60b52f51@synopsys.com>
References: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
 <6751bae2-47a9-0ab2-b20a-68e5c0df6020@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:39133 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbcGNJfB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2016 05:35:01 -0400
In-Reply-To: <6751bae2-47a9-0ab2-b20a-68e5c0df6020@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manjunath M B <Manjunath.MB@synopsys.com>, Joao.Pinto@synopsys.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 7/14/2016 10:17 AM, Joao Pinto wrote:
> On 7/12/2016 2:55 PM, Manjunath M B wrote:
>> The code was checking on PA_CONNECTEDRXLANES and
>> PA_CONNECTEDTXLANES attributes to program the Lane#1
>> attributes. The correct attributes are PA_AVAILRXDATALANES and
>> PA_AVAILTXDATALANES respectively.
>>
>> Signed-off-by: Manjunath M B <manjumb@synopsys.com>
>> ---
>>  drivers/scsi/ufs/tc-dwc-g210.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
>> index d6c5388..70db6d9 100644
>> --- a/drivers/scsi/ufs/tc-dwc-g210.c
>> +++ b/drivers/scsi/ufs/tc-dwc-g210.c
>> @@ -187,9 +187,9 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
>>  	};
>>  
>>  	/* Get the available lane count */
>> -	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
>> +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
>>  			&connected_rx_lanes);
>> -	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>> +	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
>>  			&connected_tx_lanes);
>>  
>>  	if (connected_tx_lanes == 2) {
>>

Tested-by: Joao Pinto <jpinto@synopsys.com>
