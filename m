From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 0/3 v2] SCSI: use pci_dev->revision
Date: Wed, 14 Mar 2012 22:01:39 +0300
Message-ID: <201203142201.39728.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, JBottomley@parallels.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

This patchset converts the remaining cases of reading the PCI revision register
directly to using the value already cached by PCI subsystem in the 'revision'
field of 'struct pci_dev'.

The patchset wasn't merged in either 2.6.39, 3.0, 3.1, 3.2, or 3.3 time --
hopefully it can be merged to 3.4 at least...

James B., you seem to consistently ignore this patchset without telling me what
is wrong with it; in all my attempts at submitting it I got no feedback what
so ever (except ACK on patch 3 from Vikas Chaudhary).
Andrew M., as James seem to ignore this patchset, maybe you could queue it?

All the analogous patches to other sybsystems (except these three to the SCSI
subsystem and to the Fusion MPT driver) have been merged long ago, without much
hassle...

MBR, Sergei

PS: I'm beginning to lose hope/temper... :-/
