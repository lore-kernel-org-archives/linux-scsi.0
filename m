From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/7] bnx2fc: Remove explicit logouts.
Date: Thu, 22 Oct 2015 16:54:34 +0200
Message-ID: <5628F8AA.7080207@redhat.com>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com>
 <1445283641-7358-6-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbbJVOyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Oct 2015 10:54:36 -0400
In-Reply-To: <1445283641-7358-6-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 19.10.2015 21:40, Chad Dupuis wrote:
> Explicit logouts from bnx2fc were causing race conditions in either returning
> stale SCSI commands or not allowing a target to log back in.
>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

