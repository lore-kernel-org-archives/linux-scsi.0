From: Masoud Sharbiani <msharbiani@twopensource.com>
Subject: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Mon, 5 Jan 2015 10:41:32 -0800
Message-ID: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: thenzl@redhat.com, scameron@beardog.cce.hp.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Dear stable maintainers,
Can you please backport commitid 132aa220b45d60e9b20def1e9d8be9422eed9616
 (hpsa: refine the pci enable/disable handling) to 3.10 stable (and
earlier, if applicable)?
I've tried the 3.10, and it applies cleanly there. Not sure about
earlier versions.
Many Thanks,
Masoud Sharbiani
Twitter Inc.
