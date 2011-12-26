From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 0/3] SCSI: use pci_dev->revision
Date: Mon, 26 Dec 2011 19:20:47 +0300
Message-ID: <201112261920.48250.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:36043 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755508Ab1LZPV5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Dec 2011 10:21:57 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org

Hello.

This patchset converts the remaining cases of reading the PCI revision register
directly to using the value already cached by PCI subsystem in the 'revision'
field of 'struct pci_dev'.

The patchset wasn't merged in either 2.6.39, 3.0, 3.1, or 3.2 time -- hopefully
it can be merged to 3.3 at least...

James B., you seem to consistently ignore this patchset without telling me what
is wrong with it; in all my attempts at submitting it I got no feedback what
so ever.  Andrew M., as James seem to ignore this patchset, maybe you could
queue it?

WBR, Sergei
