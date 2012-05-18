From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 00/22] qla2xxx: Updates for scsi "misc" branch.
Date: Fri, 18 May 2012 16:47:39 -0700
Message-ID: <1337384859.32217.473.camel@haakon2.linux-iscsi.org>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48493 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946177Ab2ERXrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 19:47:45 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On Tue, 2012-05-15 at 14:34 -0400, Chad Dupuis wrote:
> Hi James,
> 
> Please apply the following patches to the scsi tree at your earliest
> convenience for inclusion in the 3.5 mainline merge window.  One
> important thing to point out is that we've included the hooks for the
> new target infrastructure into the qla2xx driver with this patch set.
> We've been testing extensively the initiator mode functionalities and
> target mode components with the consolidated tree for last several
> months and we believe that it is ready for merging.
> 

Hello James & Co,

Just a friendly ping to ask about when we can expect tcm_qla2xxx to be
merged into scsi.git/for-next..?

Note the target team recently has been working addressing a race bug
specific to the area of tcm_qla2xxx session shutdown logic, but so far
the patches aren't changing any qla_target.c LLD code beyond what's
currently in patch #21 here from Chad.

That said, I'll need to rebase against your scsi/for-next once this
series is in your tree for my 3.5-rc-fixes branch for tcm_qla2xxx
bug-fixes currently in progress.

Also as mentioned, this series has no direct dependencies upon the
current 3.5 target-pending/for-next queue, so it should be nice and
pain-less merge into mainline for the emperor penguin.  :)

Please let us know if you have any concerns.

Thanks!

--nab

