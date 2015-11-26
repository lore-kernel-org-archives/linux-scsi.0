From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 0/3] arcmsr: fix bug of reallocate dma resource
Date: Thu, 26 Nov 2015 19:29:58 +0800
Message-ID: <1448537398.10768.35.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

This patch is relative to previous version v1.30.00.21-20151016.
This patch series are to fix reallocate dma resource if get_firmware_spec was called again when eh_bus_reset_handler occurred.

Patch 1 modifies codes for more readable.

Patch 2 split allocate dma resource and io register assignment from get_config to new function arcmsr_alloc_io_queue.

Patch 3 change driver version to v1.30.00.22-20151126.

--
