From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch] libsas: dereferencing variable before check
Date: Thu, 13 May 2010 01:08:05 +0200
Message-ID: <23e0bf65-8758-45b3-b0a8-1df97db07d9a@email.android.com>
References: <20100512225629.GB5695@bicker>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60659 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588Ab0EMKu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2010 06:50:27 -0400
In-Reply-To: <20100512225629.GB5695@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



"Dan Carpenter" <error27@gmail.com> wrote:

>The "qc->scsicmd" could be null so I moved the dereference inside the
>check.  This was introduced by 70b25f890: "[SCSI] fix locking around
>blk_abort_request()" 
>
>Signed-off-by: Dan Carpenter <error27@gmail.com>

Ooh.. right.

Asked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
