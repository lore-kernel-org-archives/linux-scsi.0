From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/7] scsi: storvsc: Miscellaneous enhancements and fixes
Date: Fri, 27 Mar 2015 00:26:59 -0700
Message-ID: <1427441219-29275-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This patch-set addresses perf issues discovered on the Azure storage stack.
These patches also fix a couple of bugs.

As in the first version of this patch-set, some of the patches are simply a resend.
I have bumped up the version number of all patches though. In this version, I have
addressed issues raised by Olaf Hering <olaf@aepfle.de>,
Long Li <longli@microsoft.com> and Venkatesh Srinivas <venkateshs@google.com>

K. Y. Srinivasan (7):
  scsi: storvsc: Increase the ring buffer size
  scsi: storvsc: Size the queue depth based on the ringbuffer size
  scsi: storvsc: Always send on the selected outgoing channel
  scsi: storvsc: Retrieve information about the capability of the
    target
  scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
  scsi: storvsc: Don't assume that the scatterlist is not chained
  scsi: storvsc: Set the tablesize based on the information given by
    the host

 drivers/scsi/storvsc_drv.c |  232 ++++++++++++++++++++++++++++----------------
 1 files changed, 149 insertions(+), 83 deletions(-)

-- 
1.7.4.1
