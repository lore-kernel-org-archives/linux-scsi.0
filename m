From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 0/3] nvme-fabrics: Add NVME FC Transport support to lpfc
Date: Mon, 22 Aug 2016 10:41:51 -0700
Message-ID: <a6ea99aa-a405-6438-627f-e7c904d0ac0a@broadcom.com>
References: <5792b920.7v71BUERlAKN8sK4%james.smart@broadcom.com>
 <20160811212406.GI18013@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35036 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756116AbcHVRly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 13:41:54 -0400
Received: by mail-pa0-f44.google.com with SMTP id hb8so21045311pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 10:41:54 -0700 (PDT)
In-Reply-To: <20160811212406.GI18013@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org



On 8/11/2016 2:24 PM, Christoph Hellwig wrote:
> On Fri, Jul 22, 2016 at 05:24:00PM -0700, James Smart wrote:
>> This patchset adds NVME support to the lpfc FC driver.  It reworks
>> the core driver for both NVME and SCSI protocol support, then adds the
>> nvme-over-fabrics host and target interfaces which connect to the
>> NVME FC transport lower-level api.
>>
>> Patches are cut against the linux-nvme for-4.8/drivers branch
> Before reviewing the details:  what's the plan for merging this as we'll
> have dependencies on both the SCSI and the block tree?

Good question.   With the first round of lpfc patches, I tried to ensure 
we had all the cross-protocol infrastructure in place such that the 
driver can have 2 halves that effectively run independently.  I'm hoping 
it means that I can submit scsi stuff independent from nvme stuff, but 
we'll have to see how it goes over time.

I'm open to suggestions on how best to manage the 2 trees - e.g. scsi 
stuff goes in scsi tree, and if a dependency then has to be pulled into 
block ?  nvme stuff only to block.     The initial lpfc patch set should 
have all the scsi infrastructure pulled into the 4.8 merge, so hopefully 
that dependency has been resolved already.

-- james


Any recommendations ?
