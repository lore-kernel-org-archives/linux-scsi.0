From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH] lpfc: add missing Kconfig NVME dependencies
Date: Thu, 23 Feb 2017 07:51:35 -0800
Message-ID: <523a2eb4-7d02-9ec8-8e81-9d1112cdc98e@gmail.com>
References: <58adba5f.BoP49Cv2S5zD9ZuD%jsmart2021@gmail.com>
 <20170223100938.GA20495@infradead.org>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:32844 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdBWPvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 10:51:39 -0500
In-Reply-To: <20170223100938.GA20495@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: hare@suse.com, martin.petersen@oracle.com, dick.kennedy@broadcom.com, linux-next@vger.kernel.org, sfr@canb.auug.org.au, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 2/23/2017 2:09 AM, Christoph Hellwig wrote:
> On Wed, Feb 22, 2017 at 08:20:47AM -0800, James Smart wrote:
>> add missing Kconfig NVME dependencies
>>
>> Can't believe I missed posting this
> Oh.  I'm not sure everyone is happy having to drag in the whole
> nvme and nvme target stack when building lpfc.  Is there a way
> to make nvme optional?  And in the future scsi as well?

yes - I'll work on doing that.  Scsi is a little further off as the fc 
transport has to be dealt with - moved out from under scsi and put above 
scsi and nvme in the device tree.  The transport is where the hooks for 
adapter mgmt are right now.

-- james
