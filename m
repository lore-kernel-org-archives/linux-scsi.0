From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 6 Feb 2017 08:52:54 +0000
Message-ID: <13e199bd-400f-d2e3-7896-d45c07bede51@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru>
 <73a398a7-bde4-d337-0954-bc0f8d2f3752@ojab.ru>
 <dd9f95e5-0812-521b-e060-f0fdf7283348@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34018 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdBFIwy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 03:52:54 -0500
Received: by mail-lf0-f66.google.com with SMTP id q89so3298402lfi.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 00:52:53 -0800 (PST)
In-Reply-To: <dd9f95e5-0812-521b-e060-f0fdf7283348@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 2017/01/30 10:58, ojab wrote:
> On 2017/01/23 15:59, ojab wrote:
>> On 2016/12/28 11:05, ojab wrote:
>>> MPI2 controllers sometimes got lost (i. e. disappears from
>>> /sys/bus/pci/devices) if ASMP is enabled.
>>>
>>> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
>>> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644
>>
>> Can I haz Reviewed-by?
>>
>
> ping?
>

Humble ping.

//wbr ojab
