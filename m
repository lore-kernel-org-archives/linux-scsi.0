From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: Re: [PATCH] st: use dev_printk() to avoid linebreaks in kernel messages.
Date: Fri, 21 Feb 2014 11:48:59 +0900
Message-ID: <5306BE9B.1010909@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
in-reply-to: 53047DA0.4030100@suse.de
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de
Cc: mlombard@redhat.com, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org, jbottomley@parallels.com, kay@vrfy.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, hidehiro.kawai.ez@hitachi.com, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Hi Hannes,

We want to handle the error message in userland for HA clusters, so the
error messages should be output in single(atomic) line. However, current
upstream kernel outputs SCSI error messages in multiple lines, so
current implementation is inconvenient. Even if human reads the error
messages, the split messages are difficult to read. Therefore, the
split error messages should be fixed.

In order to solve this problem, recently I submitted the patch fixing
SCSI error message split[1] to LKML. However, when I read the
discussion of you and Maurizio, I noticed that you already have fixed
in your branch.

When will you send your branch to linux-kernel ML or linux-scsi ML?

[1] https://lkml.org/lkml/2014/1/15/926
[2] http://marc.info/?t=139280071900001&r=1&w=2

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
