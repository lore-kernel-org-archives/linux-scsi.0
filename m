From: Chris Boot <bootc@boo.tc>
Subject: Re: [PATCH] sbp-target: Delete an error message for a failed memory
 allocation in three functions
Date: Sun, 10 Dec 2017 21:51:07 +0000
Message-ID: <e482cc36-285c-4402-7cbf-a335428a5710@boo.tc>
References: <06164454-67a9-d206-647c-b70f4a1c3812@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40937 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751263AbdLJV5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Dec 2017 16:57:54 -0500
In-Reply-To: <06164454-67a9-d206-647c-b70f4a1c3812@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On 10/12/2017 19:10, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 10 Dec 2017 19:54:11 +0100
> 
> Omit an extra message for a memory allocation failure in these functions.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[snip]

Looks good to me.

Acked-by: Chris Boot <bootc@boo.tc>

Thanks,
Chris

-- 
Chris Boot
bootc@boo.tc
