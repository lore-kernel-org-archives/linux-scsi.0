From: James Smart <jsmart2021@gmail.com>
Subject: Re: [bug report] scsi: lpfc: NVME Target: Base modifications
Date: Sat, 4 Mar 2017 09:46:39 -0800
Message-ID: <23b724bc-5794-93fe-c95a-38cb52e5d066@gmail.com>
References: <20170227164848.GA30526@mwanda>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33895 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752107AbdCDRzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:55:19 -0500
Received: by mail-qk0-f194.google.com with SMTP id g129so6482263qkd.1
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:55:06 -0800 (PST)
In-Reply-To: <20170227164848.GA30526@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org



On 2/27/2017 8:48 AM, Dan Carpenter wrote:
> Hello James Smart,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch f358dd0ca26c: "scsi: lpfc: NVME Target: Base modifications"
> from Feb 12, 2017, leads to the following Smatch complaint:
>
>


Thanks.  Issues were addressed by patch from Colin King, and pushed in 
the lpfc patch set just posted.
see  http://marc.info/?l=linux-scsi&m=148864866415099&w=2

-- james
