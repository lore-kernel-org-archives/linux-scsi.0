From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] scsi: storvsc: Some enhancements
Date: Fri, 27 Feb 2015 16:43:47 -0800
Message-ID: <1425084227-27224-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

While testing on some high latency storage backends, to get the advertised IOPS,
we have to increase the size of the ringbuffer. Address this issue.

K. Y. Srinivasan (3):
  scsi: storvsc: Increase the ring buffer size
  Scsi: storvsc: Size the queue depth based on the ringbuffer size
  scsi: storvsc: Always send on the selected outgoing channel

 drivers/scsi/storvsc_drv.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

-- 
1.7.4.1
