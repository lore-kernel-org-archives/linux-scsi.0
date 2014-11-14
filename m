From: Masoud Sharbiani <msharbiani@twopensource.com>
Subject: Backport of a fix for a race condition in HPSA driver (3rd time is
 the charm)
Date: Fri, 14 Nov 2014 11:26:08 -0800
Message-ID: <CANcb+4vTzLBGkkvrBo-dsCERFvX-J=D-4Sgx6Vz_-e1jJpokYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: thenzl@redhat.com, scameron@beardog.cce.hp.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear stable maintainers,
Can you please backport commitid
2cc5bfaf854463d9d1aa52091f60110fbf102a9 ([SCSI] hpsa: fix a race in
cmd_free/scsi_done) to 3.10 stable (and earlier, if applicable)? It
seems to fix an issue that we have run into a couple of times.

Many thanks,
Masoud Sharbiani <msharbiani@twitter.com> <msharbiani@twopensource.com>

PS: Apologies for duplicate message that may have been captured in
your spam folder.
