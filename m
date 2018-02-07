From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 01/13] lpfc: Rework lpfc to allow different sli4 cq and eq
 handlers
Date: Tue, 6 Feb 2018 18:01:32 -0800
Message-ID: <d56eadb1-385c-2160-016f-a0d66c630508@gmail.com>
References: <20180126193113.29610-1-jsmart2021@gmail.com>
 <20180126193113.29610-2-jsmart2021@gmail.com> <yq1mv0l3as0.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:36536 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbeBGCBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 21:01:34 -0500
Received: by mail-yw0-f178.google.com with SMTP id q6so2845370ywg.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 18:01:34 -0800 (PST)
In-Reply-To: <yq1mv0l3as0.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 2/6/2018 4:26 PM, Martin K. Petersen wrote:
> 
> James,
> 
> I was on the verge of applying this as well but saw that you intended a
> re-spin. Found a few typos while poring over these patches:
> 
>> Prepare the code for new hardwre by creating a sli4-based callout
> 
> hardware
> 
>> table that can be set based on if_type.
> 

ok - I'll correct what's been pointed out and repost. Thanks

-- james
