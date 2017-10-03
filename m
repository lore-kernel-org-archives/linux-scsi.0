From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 00/21] lpfc updates for 11.4.0.4
Date: Tue, 3 Oct 2017 11:13:44 -0700
Message-ID: <ed6758d7-9237-a556-4fac-df81d6e9c19f@broadcom.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
 <yq1o9pp0x0e.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:53811 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdJCSNp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 14:13:45 -0400
Received: by mail-pf0-f177.google.com with SMTP id y24so1717146pfa.10
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2017 11:13:45 -0700 (PDT)
In-Reply-To: <yq1o9pp0x0e.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: linux-scsi@vger.kernel.org

Martin,

Contents of 4.15/scsi-queue look good.

-- james


On 10/2/2017 7:45 PM, Martin K. Petersen wrote:
> James,
>
>> This patch set provides a number of bug fixes and additions to
>> the driver.
>>
>> The patches were cut against the Martin's 4.14/scsi-queue tree.
>> There are no outside dependencies.
> Applied to 4.15/scsi-queue.
>
> I got a conflict in patch 8 in the "Process all the event on FCP
> fast-path EQ" hunk. Please verify.
>
