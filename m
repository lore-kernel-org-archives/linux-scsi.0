From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0005] Staging: hv: storvsc cleanup
Date: Thu,  1 Dec 2011 04:58:35 -0800
Message-ID: <1322744315-13017-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Cleanup storvsc driver  based on review comments from James.

	1) While the existing per (virtual) HBA memory pools mechanism
	   does address the deadlock issues raised earlier since for IDE
	   devices there is a HBA per device and presently only IDE devices
	   can be drain devices, here we implement a generic per-LUN memory
	   pools mechanism.

	2) Fix a couple of bugs in the bounce buffer handling code (now that I
	   have been able to trigger these code paths!)

	3) Cleanup some unnecessary code.

With this, I believe I have addressed all of the review comments I have received
on this driver. I will submit a separate patch for moving the driver out of staging
(that includes these patches).


Regards,

K. Y
