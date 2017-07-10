From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] ses: do not add a device to an enclosure if
 enclosure_add_links() fails.
Date: Mon, 10 Jul 2017 15:46:03 +0200
Message-ID: <a1f7e95e-1b60-a9a1-38a7-12454535a89b@redhat.com>
References: <1498557207-12364-1-git-send-email-mlombard@redhat.com>
 <bdbe2093-8abc-b48d-7a23-0734fadf33ac@linux.vnet.ibm.com>
 <7d12dd37-74b9-5593-bfcc-3a375baacf65@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932079AbdGJNqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jul 2017 09:46:08 -0400
In-Reply-To: <7d12dd37-74b9-5593-bfcc-3a375baacf65@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Miller <dougmill@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

Douglas,

> Has there been any progress with getting this patch accepted?
> 

It has been merged already.
It's in linux-next, commit 62e62ffd95539b9220894a7900a619e0f3ef4756

https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next/+/62e62ffd95539b9220894a7900a619e0f3ef4756

Maurizio.
