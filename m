From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: Configuring the device_list in scsi_scan.c
Date: Thu, 30 May 2002 17:18:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C5EA4@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We just ran into an issue where the RAID array we purchased didn't quite
work with Linux, because only the first LUN was visible (Red Hat
2.4.7-10).

I patched the kernel by adding the array to the device_list in
scsi_scan.c, but that seems obnoxious. It occurs to me that it would be
straight forward to modify scsi.c and scsi_scan.c so that you could
write to /proc/scsi/scsi and add new entries to the device_list; and a
module parameter that would let you add a single new entry to the
device_list right at load time.

Before I start fighting with my boss over whether I have time to write
patches for the linux kernel - does this fix make sense?
