From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: ["PATCH-v2" 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 10:24:06 -0400
Message-ID: <yq14lxhn8jd.fsf@oracle.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
        <a8ba07f3-348e-4ae4-010b-1c9ff63b6f0d@grimberg.me>
        <20170421062258.GA30237@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27401 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040941AbdDUOZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 10:25:36 -0400
In-Reply-To: <20170421062258.GA30237@infradead.org> (Christoph Hellwig's
        message of "Thu, 20 Apr 2017 23:22:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@infradead.org>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com


James,

> Also James once you do that please run the patches through sparse,
> there are a few warnings in the changes, although they mostly seem
> to replace old warnings with different ones.

I'll let you know when 4.12/scsi-fixes is ready and you can use that as
baseline. Depends when Linus decides to pull the trigger. Probably early
next week.

PS. Looks like your patch versioning is homegrown, the format is not
quite right and it befuddles both my scripts and patchworks. Please use
git-send-email --compose -vN (where N is the version) when resubmitting
a patch or series to ensure things get formatted correctly.

-- 
Martin K. Petersen	Oracle Linux Engineering
