From: James Smart <jsmart2021@gmail.com>
Subject: Re: [bug report] scsi: lpfc: NVME Target: Receive buffer updates
Date: Sat, 4 Mar 2017 09:45:26 -0800
Message-ID: <749bd8b4-6b58-4598-0445-e702f2db9757@gmail.com>
References: <20170227164349.GA22044@mwanda>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34592 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdCDRqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:46:22 -0500
Received: by mail-qk0-f196.google.com with SMTP id g129so6444877qkd.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:45:28 -0800 (PST)
In-Reply-To: <20170227164349.GA22044@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org



On 2/27/2017 8:44 AM, Dan Carpenter wrote:
> Hello James Smart,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 2d7dbc4c2775: "scsi: lpfc: NVME Target: Receive buffer
> updates" from Feb 12, 2017, leads to the following Smatch complaint:
>
>

Thanks.  Issues were addressed by patch from Colin King, and pushed in 
the lpfc patch set just posted.
see http://marc.info/?l=linux-scsi&m=148864866515100&w=2

-- james
