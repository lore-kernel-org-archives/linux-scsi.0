From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 12/15] lpfc: Cleanup entry_repost settings on SLI4 queues
Date: Mon, 15 May 2017 15:13:44 -0700
Message-ID: <ac3b9ca1-ce3f-02e2-8783-701939c46303@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-13-jsmart2021@gmail.com>
 <1f3ad2eb-4db8-5181-02d9-cde8d43e952c@suse.de>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35169 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdEOWNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 18:13:49 -0400
Received: by mail-wm0-f67.google.com with SMTP id v4so32230684wmb.2
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 15:13:48 -0700 (PDT)
In-Reply-To: <1f3ad2eb-4db8-5181-02d9-cde8d43e952c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 5/11/2017 12:49 AM, Hannes Reinecke wrote:
> If this is a fix to a previous patch (Patch 6/15 ?), please merge it
> with that.

It was, in some areas.  Split those areas out and merged into the prior 
patches. Affected patches 0004, 0006, and 0008.

-- james
