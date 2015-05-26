From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH 3/9] lpfc: Devices are not discovered during takeaway/giveback
 testing
Date: Tue, 26 May 2015 09:36:32 -0400
Message-ID: <556476E0.5020004@avagotech.com>
References: <555f405d.19aP4Ju4SItrRE4D%james.smart@avagotech.com> <20150524215643.00003055@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35708 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbEZNgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 09:36:51 -0400
Received: by qkdn188 with SMTP id n188so88735601qkd.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2015 06:36:34 -0700 (PDT)
In-Reply-To: <20150524215643.00003055@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

uh - we're flagging issues with in a patch explanation (such as 2 spaces 
after a period) and not something in the patch itself ??

I'm not going to revise patches for minor typos or styles disagreements 
in patch descriptions.

-- james


On 5/24/2015 3:56 PM, Sebastian Herbszt wrote:
> James Smart wrote:
>> Devices are not discovered during takeaway/giveback testing
>>
>> When a remote nport changes it's DID, a new ndlp is used.
> its
>
>> However, we left the old ndlp state unchanged and still in
>> a discovery state. The may stall discovery resulting in some
> The?
>
>> devices not being discovered.  Correct by swapping the state
> two spaces
>
>> of the 2 ndlp's when a DID swap is detected.
> Sebastian

