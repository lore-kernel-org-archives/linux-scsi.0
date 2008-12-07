From: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Subject: [Bug #11898] mke2fs hang on AIC79 device.
Date: Sun,  7 Dec 2008 21:32:52 +0100 (CET)
Message-ID: <07Xes05z25M.A.QoG.XuEPJB@chimera>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6VnlupFpCsN.A.2rE.MsEPJB@chimera>
Content-Disposition: inline
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alexs <alex.shi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux SCSI list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, Yanmin Zhang <yanmin_zhang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This message has been generated automatically as a part of a report
of recent regressions.

The following bug entry is on the current list of known regressions
from 2.6.27.  Please verify if it still should be listed and let me know
(either way).


Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11898
Subject		: mke2fs hang on AIC79 device.
Submitter	: alexs <alex.shi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date		: 2008-10-30 01:17 (39 days old)
First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f0c0a376d0fcd4c5579ecf5e95f88387cba85211
Handled-By	: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
		  Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11898#c28
		  http://bugzilla.kernel.org/show_bug.cgi?id=11898#c36
