From: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
Subject: WalB: a wrapper block device driver for efficient backup and replication
Date: Mon, 03 Jun 2013 17:30:26 +0900
Message-ID: <51AC5422.1080103@labs.cybozu.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
List-Id: linux-scsi@vger.kernel.org

Hello,

I'm developing a wrapper block device driver called 'WalB'
that provides wrapper block devices to get consistent diff blocks
without full-scans of devices using Write-Ahead Logging technology,
in order to achieve incremental backup and asynchronous replication.

Its source code and documents are available in GitHub:
https://github.com/starpos/walb
https://github.com/starpos/walb/blob/develop/doc/index.creole

You can try it from now.
It supports kernel 3.2 to 3.9 and x86_64 architecture currently.

WalB achieves small overhead of IO response with:
- No persistent indexes.
- No undo-logs, just redo-logs.
- No block-level fragmentation.

I've talked about WalB at LinuxCon Japan 2013.
The slides in pdf are here:
http://www.slideshare.net/starpos/wal-b-linuxconjapan2013

At the conference, I asked Mr. Ric Wheeler what to do for the module to
be merged to the mainline kernel, and he suggested submitting an e-mail
ASAP.

WalB is provided as a single module currently.
It seems not so difficult to create 'drivers/block/walb' directory like
DRBD.
Is that nice idea? or do you have any comments?

Regards,

Takashi Hoshino
