From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI handling
Date: Mon, 19 Jun 2017 13:26:45 -0700
Message-ID: <9df75431-74d4-20a1-4a5c-464f09345812@broadcom.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-2-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34507 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdFSU0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 16:26:49 -0400
Received: by mail-qk0-f172.google.com with SMTP id d14so42769082qkb.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 13:26:48 -0700 (PDT)
In-Reply-To: <20170616224744.3681-2-himanshu.madhani@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
>   
>   /* FCP-4 types */
>   #define FC4_TYPE_FCP_SCSI	0x08
> +#define FC4_TYPE_NVME		0x28
>   #define FC4_TYPE_OTHER		0x0
>   #define FC4_TYPE_UNKNOWN	0xff

please use the types from include/uapi/scsi/fc/fc_fs.h
