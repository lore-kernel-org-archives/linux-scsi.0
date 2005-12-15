From: "Miquel van Smoorenburg" <miquels@cistron.nl>
Subject: Re: [GIT PATCH] final SCSI fixes for 2.6.15-rc5
Date: Thu, 15 Dec 2005 10:10:01 +0000 (UTC)
Message-ID: <dnrfdp$6nl$1@news.cistron.nl>
References: <1134604909.11150.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422687AbVLOKKF@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In article <1134604909.11150.2.camel@mulgrave>,
James Bottomley  <James.Bottomley@SteelEye.com> wrote:
>These should (hopefully) represent the last few urgent bug fixes that
>have shown up.  The fixes are available here:
>
>master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

While not technically a SCSI driver, dpt_i2o lives in drivers/scsi
and there is a critical fix in the -mm tree that needs to go
into 2.6.15:

dpt_i2o-fix-for-deadlock-condition.patch

I've experienced several hard lockups in dpt_i2o and I have reports
of other people that have the same problem - they are solved with
this patch. It's a pure bugfix, in 2.6.13 the scsi error recovery
api was changed wrt locking and dpt_i2o only got partially updated.

It probably needs to go into 2.6.14.stable too..

Mike.
