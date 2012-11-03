From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Drivers: scsi
Date: Sat,  3 Nov 2012 09:40:06 -0700
Message-ID: <1351960806-16240-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Do we currently support dynamic re-sizing of LUNs. Hyper-V can
notify capacity change via sense data and I was wondering if this
is handled in the generic scsi code.


Regards,

K. Y
