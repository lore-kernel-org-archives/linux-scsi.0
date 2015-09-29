From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/3] scsi: Some miscellaneous fixes
Date: Tue, 29 Sep 2015 15:33:57 +0200
Message-ID: <87h9md2vui.fsf@vitty.brq.redhat.com>
References: <1442528938-3252-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964967AbbI2NeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 09:34:03 -0400
In-Reply-To: <1442528938-3252-1-git-send-email-kys@microsoft.com>
	(K. Y. Srinivasan's message of "Thu, 17 Sep 2015 15:28:58 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com

"K. Y. Srinivasan" <kys@microsoft.com> writes:

[...]

>
> Vitaly Kuznetsov (2):
>   scsi_scan: don't dump trace when scsi_prep_async_scan() is called
>     twice
>   scsi: introduce short_inquiry flag for broken host adapters

James,

I'm sorry for the annoyance but when I asked about these patches last
time you said we don't have them reviewed. Is it OK now when we have
signed-off-by: from K. Y. or do we need to ask someone else?

Thanks,

-- 
  Vitaly
