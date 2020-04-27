Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA847C7C881
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBDB2078C
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tJuDZKxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgD0OLb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:11:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50880 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727902AbgD0OLa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:11:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RDwgcp122673;
        Mon, 27 Apr 2020 14:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Wa9PDmgzkzn0YtjxVYxn+dHBEN6HBXROnWRC8fL2f6Q=;
 b=tJuDZKxvqjB8M9Q0JI0TtBb5x2OwCYyKsigCsb1WBy3ASfO81tZNdN/BwiewacLADDZ1
 qkCeDn21O3XUML2+3jR5tkXKKSAbV/nlVaOfAXkxdidsh2YXO4iT9qnq6XR/aqMIergN
 k72A/Qqd199HznWrVLNfRQDsuIrPubXuDwgNgEyuSHauBlHG1eqHhebxfSWWV51K9gdb
 XW4jZtp+8kdZEnX1axaktgYo3NLDHSG+RwnSZU5ivUu2TyHihBbKH7i3bKn+4HbPePz/
 eTrI0TAm13NXHO3+M9e1/wG7A+pOB1covam8HnZbxnLXILmjFckSgWDODrrfncLY+swP Kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30nucfst3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:11:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RE85hI179740;
        Mon, 27 Apr 2020 14:09:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30mxrqcbty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:09:16 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RE9ErG009166;
        Mon, 27 Apr 2020 14:09:14 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:09:14 -0700
Subject: Re: [PATCH v4 01/11] qla2xxx: Fix spelling of a variable name
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-2-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <eb7bc9e4-0473-7b67-92ea-12dd77f1aa74@oracle.com>
Date:   Mon, 27 Apr 2020 09:09:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h   | 2 +-
>   drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index f9bad5bd7198..b364a497e33d 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1292,7 +1292,7 @@ struct device_reg_24xx {
>   };
>   /* RISC-RISC semaphore register PCI offet */
>   #define RISC_REGISTER_BASE_OFFSET	0x7010
> -#define RISC_REGISTER_WINDOW_OFFET	0x6
> +#define RISC_REGISTER_WINDOW_OFFSET	0x6
>   
>   /* RISC-RISC semaphore/flag register (risc address 0x7016) */
>   
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 80390d3f3236..b94429504d30 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2861,7 +2861,7 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
>   	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>   
>   	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
> +	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET);
>   
>   }
>   
> @@ -2871,7 +2871,7 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
>   	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>   
>   	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
> +	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET, data);
>   }
>   
>   static void
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
