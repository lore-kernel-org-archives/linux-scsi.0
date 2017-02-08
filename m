From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Tue, 7 Feb 2017 18:32:30 -0800
Message-ID: <52f4f81e-2353-4da2-7ce9-a7cd7796e1f7@gmail.com>
References: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
 <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:36695 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdBHCcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 21:32:33 -0500
Received: by mail-yb0-f195.google.com with SMTP id o65so5627430ybo.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Feb 2017 18:32:33 -0800 (PST)
In-Reply-To: <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org



On 2/7/2017 1:03 AM, Johannes Thumshirn wrote:
>
> Yes but patch  03/18 'lpfc: NVME Initiator: Base modifications Part A'
> still has calls to lpfc_sli_hbq_count(phba) (and in fact introduces this
> change).
>

I realize I cut these in a silly way.  In the v1 patches, I had a big 
patch that I then cut into 6 parts, by file.  In the v2 patches, I tried 
to keep the patches as is, and address the comments in the respective 
patch the comment came from. Which resulted in 3/8 with an old 
reference, but patch 8/8 being the one that reverted this reverence. 
Sorry..  I'll recut and repost.

-- james
