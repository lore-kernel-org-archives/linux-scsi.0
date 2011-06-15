From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] fusion: don't use flush_scheduled_work()
Date: Wed, 15 Jun 2011 15:39:15 +0200
Message-ID: <20110615133915.GX8141@htj.dyndns.org>
References: <1295877451-16602-1-git-send-email-tj@kernel.org>
 <1295877451-16602-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57635 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1FONjU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 09:39:20 -0400
Received: by fxm17 with SMTP id 17so400169fxm.19
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2011 06:39:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1295877451-16602-5-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

On Mon, Jan 24, 2011 at 02:57:31PM +0100, Tejun Heo wrote:
> mptscsih_suspend() does flush_scheduled_work() but mptscsih is the
> only one using the system_wq.  Make mptspi use its own workqueue, and
> on suspend, flush it and then call mptscsih_suspend().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Eric Moore <Eric.Moore@lsi.com>

Ping on this one too.  I'm quite close to marking
flush_scheduled_work() deprecated in linux-next and this is one of few
holdouts outside of staging.  It would be great if this patch can
appear in linux-next soon.

Thank you.

-- 
tejun
