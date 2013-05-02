From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 5/5] scsi: ufs: add dme operations
Date: Thu, 2 May 2013 13:37:40 +0530
Message-ID: <CALMYJDtB0rEGMaqZ5XbkcBNkaHYvoVc_BiPEYJpSsH2fF1H_Qw@mail.gmail.com>
References: <002201ce4105$b6a26120$23e72360$%jun@samsung.com> <CALMYJDt3j_mZNdOiN44ZiwtDQUQEKLuoaTWt5nMgvBfChLd+SQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:56711 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3EBIIB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 04:08:01 -0400
Received: by mail-bk0-f52.google.com with SMTP id q16so130992bkw.11
        for <linux-scsi@vger.kernel.org>; Thu, 02 May 2013 01:08:00 -0700 (PDT)
In-Reply-To: <CALMYJDt3j_mZNdOiN44ZiwtDQUQEKLuoaTWt5nMgvBfChLd+SQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Thu, May 2, 2013 at 1:36 PM, Santosh Y <santoshsy@gmail.com> wrote:
>> +/*
>> + * drivers/scsi/ufs/ufs-attrs.h
>> + *
>> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef _UFS_ATTRS_H_
>> +#define _UFS_ATTRS_H_
>> +
>> +/*
>> + * PHY Adpater attributes
>> + */
>> +#define PA_ACTIVETXDATALANES   0x1560
>> +#define PA_ACTIVERXDATALANES   0x1580
>> +#define PA_TXTRAILINGCLOCKS    0x1564
>> +#define PA_PHY_TYPE            0x1500
>> +#define PA_AVAILTXDATALANES    0x1520
>> +#define PA_AVAILRXDATALANES    0x1540
>> +#define PA_MINRXTRAILINGCLOCKS 0x1543
>> +#define PA_TXPWRSTATUS         0x1567
>> +#define PA_RXPWRSTATUS         0x1582
>> +#define PA_TXFORCECLOCK                0x1562
>> +#define PA_TXPWRMODE           0x1563
>> +#define PA_LEGACYDPHYESCDL     0x1570
>> +#define PA_MAXTXSPEEDFAST      0x1521
>> +#define PA_MAXTXSPEEDSLOW      0x1522
>> +#define PA_MAXRXSPEEDFAST      0x1541
>> +#define PA_MAXRXSPEEDSLOW      0x1542
>> +#define PA_TXLINKSTARTUPHS     0x1544
>> +#define PA_TXSPEEDFAST         0x1565
>> +#define PA_TXSPEEDSLOW         0x1566
>> +#define PA_REMOTEVERINFO       0x15A0
>> +#define PA_TXGEAR              0x1568
>> +#define PA_TXTERMINATION       0x1569
>> +#define PA_HSSERIES            0x156A
>> +#define PA_PWRMODE             0x1571
>> +#define PA_RXGEAR              0x1583
>> +#define PA_RXTERMINATION       0x1584
>> +#define PA_MAXRXPWMGEAR                0x1586
>> +#define PA_MAXRXHSGEAR         0x1587
>> +#define PA_RXHSUNTERMCAP       0x15A5
>> +#define PA_RXLSTERMCAP         0x15A6
>> +#define PA_PACPREQTIMEOUT      0x1590
>> +#define PA_PACPREQEOBTIMEOUT   0x1591
>> +#define PA_LOCALVERINFO                0x15A9
>> +#define PA_TACTIVATE           0x15A8
>> +#define PA_PACPFRAMECOUNT      0x15C0
>> +#define PA_PACPERRORCOUNT      0x15C1
>> +#define PA_PHYTESTCONTROL      0x15C2
>> +#define PA_PWRMODEUSERDATA0    0x15B0
>> +#define PA_PWRMODEUSERDATA1    0x15B1
>> +#define PA_PWRMODEUSERDATA2    0x15B2
>> +#define PA_PWRMODEUSERDATA3    0x15B3
>> +#define PA_PWRMODEUSERDATA4    0x15B4
>> +#define PA_PWRMODEUSERDATA5    0x15B5
>> +#define PA_PWRMODEUSERDATA6    0x15B6
>> +#define PA_PWRMODEUSERDATA7    0x15B7
>> +#define PA_PWRMODEUSERDATA8    0x15B8
>> +#define PA_PWRMODEUSERDATA9    0x15B9
>> +#define PA_PWRMODEUSERDATA10   0x15BA
>> +#define PA_PWRMODEUSERDATA11   0x15BB
>> +#define PA_CONNECTEDTXDATALANE 0x1561
>> +#define PA_CONNECTEDRXDATALANE 0x1581
>> +#define PA_LOGICALLANEMAP      0x15A1
>> +#define PA_SLEEPNOCONFIGTIME   0x15A2
>> +#define PA_STALLNOCONFIGTIME   0x15A3
>> +#define PA_SAVECONFIGTIME      0x15A4
>> +
>> +/*
>> + * Data Link Layer Attributes
>> + */
>> +#define DL_TC0TXFCTHRESHOLD    0x2040
>> +#define DL_FC0PROTTIMEOUTVAL   0x2041
>> +#define DL_TC0REPLAYTIMEOUTVAL 0x2042
>> +#define DL_AFC0REQTIMEOUTVAL   0x2043
>> +#define DL_AFC0CREDITTHRESHOLD 0x2044
>> +#define DL_TC0OUTACKTHRESHOLD  0x2045
>> +#define DL_TC1TXFCTHRESHOLD    0x2060
>> +#define DL_FC1PROTTIMEOUTVAL   0x2061
>> +#define DL_TC1REPLAYTIMEOUTVAL 0x2062
>> +#define DL_AFC1REQTIMEOUTVAL   0x2063
>> +#define DL_AFC1CREDITTHRESHOLD 0x2064
>> +#define DL_TC1OUTACKTHRESHOLD  0x2065
>> +#define DL_TXPREEMPTIONCAP     0x2000
>> +#define DL_TC0TXMAXSDUSIZE     0x2001
>> +#define DL_TC0RXINITCREDITVAL  0x2002
>> +#define DL_TC0TXBUFFERSIZE     0x2005
>> +#define DL_PEERTC0PRESENT      0x2046
>> +#define DL_PEERTC0RXINITCREVAL 0x2047
>> +#define DL_TC1TXMAXSDUSIZE     0x2003
>> +#define DL_TC1RXINITCREDITVAL  0x2004
>> +#define DL_TC1TXBUFFERSIZE     0x2006
>> +#define DL_PEERTC1PRESENT      0x2066
>> +#define DL_PEERTC1RXINITCREVAL 0x2067
>> +
>> +/*
>> + * Network Layer Attributes
>> + */
>> +#define N_DEVICEID             0x3000
>> +#define N_DEVICEID_VALID       0x3001
>> +#define N_TC0TXMAXSDUSIZE      0x3020
>> +#define N_TC1TXMAXSDUSIZE      0x3021
>> +
>> +/*
>> + * Transport Layer Attributes
>> + */
>> +#define T_NUMCPORTS            0x4000
>> +#define T_NUMTESTFEATURES      0x4001
>> +#define T_CONNECTIONSTATE      0x4020
>> +#define T_PEERDEVICEID         0x4021
>> +#define T_PEERCPORTID          0x4022
>> +#define T_TRAFFICCLASS         0x4023
>> +#define T_PROTOCOLID           0x4024
>> +#define T_CPORTFLAGS           0x4025
>> +#define T_TXTOKENVALUE         0x4026
>> +#define T_RXTOKENVALUE         0x4027
>> +#define T_LOCALBUFFERSPACE     0x4028
>> +#define T_PEERBUFFERSPACE      0x4029
>> +#define T_CREDITSTOSEND                0x402A
>> +#define T_CPORTMODE            0x402B
>> +#define T_TC0TXMAXSDUSIZE      0x4060
>> +#define T_TC1TXMAXSDUSIZE      0x4061
>> +
>> +#endif /* _UFS_ATTRS_H_ */
>
>
> These are Unipro. So change the name of the file to unipro.h
>
 I meant Unipro attributes, So change the name accordingly.

>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 76ff332..55575ea 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -37,6 +37,7 @@
>>
>>  #define UFSHCD_ENABLE_INTRS    (UTP_TRANSFER_REQ_COMPL |\
>>                                  UTP_TASK_REQ_COMPL |\
>> +                                UFSHCD_HIBERNATE_MASK |\
>>                                  UFSHCD_ERROR_MASK)
>>  #define UIC_CMD_TIMEOUT        100
>>
>> @@ -188,6 +189,31 @@ static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
>>  }
>>
>
>
> --
> ~Santosh



-- 
~Santosh
