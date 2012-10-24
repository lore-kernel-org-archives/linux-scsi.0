From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Drivers: scsi
Date: Wed, 24 Oct 2012 09:25:38 -0700
Message-ID: <1351095938-12204-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When the low level driver returns SCSI_MLQUEUE_DEVICE_BUSY,
how is the command retried; I suspect the retry is done after some delay.
Is this delay programmable? If the device state changes,
can the low level driver notify upper layers that it can now handle
the command that it had failed earlier with SCSI_MLQUEUE_DEVICE_BUSY.

Regards,

K. Y
