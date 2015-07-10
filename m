From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix incorrect trace indexing
Date: Fri, 10 Jul 2015 16:19:49 -0300
Message-ID: <87380vbz1m.fsf@linux.vnet.ibm.com>
References: <201506222233.t5MMXpZR011546@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <201506222233.t5MMXpZR011546@d03av04.boulder.ibm.com> (Brian
	King's message of "Mon, 22 Jun 2015 17:33:50 -0500")
Sender: stable-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

> One more ipr patch to go on top of my previous series I sent. This one fixes
> a pretty nasty bug that can cause us to go writing in memory that is not ours.
>

Please add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Thanks,

-- 
Gabriel Krisman Bertazi
