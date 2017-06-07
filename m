From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 00/17] lpfc updates for 11.4.0.0
Date: Tue, 6 Jun 2017 21:20:08 -0700
Message-ID: <bd39df43-3f6c-c799-37a7-ede5790540d8@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
 <yq14lvtex4v.fsf@oracle.com>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34045 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdFGEUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2017 00:20:12 -0400
Received: by mail-pf0-f194.google.com with SMTP id u1so314324pfg.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2017 21:20:12 -0700 (PDT)
In-Reply-To: <yq14lvtex4v.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 6/5/2017 6:13 PM, Martin K. Petersen wrote:
> 
> Hi James,
> 
>> This patch set provides a number of bug fixes, code cleanups, and
>> error handling in lpfc.
>>
>> The patches were cut against the Martin's 4.12/scsi-fixes tree.  There
>> are no outside dependencies. The patches should merge via Martin's
>> tree.
> 
> We're approaching rc5 and there are several hundred-liners in this
> submission. The EQ delay logic patch in particular looks like a feature
> rather than a bug fix.
> 
> How many of these are critical to get into 4.12 vs. 4.13?
> 


What can be excluded: patch 04 and 16.

All others I'd like to get in 4.12

-- james
