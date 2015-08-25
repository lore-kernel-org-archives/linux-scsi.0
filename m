From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH V6 07/10] [SCSI] aacraid: Unblock IOCTLs to controller
 once system resumed from suspend
Date: Tue, 25 Aug 2015 16:49:19 +0200
Message-ID: <55DC806F.7000704@redhat.com>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbbHYOtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2015 10:49:22 -0400
In-Reply-To: <1439272701-15344-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> Description:
> 	Driver blocks ioctls once it received shutdown/suspend request during
> 	suspend/hybernation. This patch unblocks ioctls on resume path.
>
> Changes from V2:
> None
>
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

