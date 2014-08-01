From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v1.3 0/18] arcmsr: bugfix, new features and support new
 adapters
Date: Fri, 01 Aug 2014 16:10:43 +0800
Message-ID: <1406880643.10378.17.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

This patches are made against the git://git.infradead.org/users/hch/scsi-queue.git/tree/drivers/scsi/arcmsr/

This patches series address following issues.

1. Bugfix for command timeout, abort and ioctl error.

2. Add new feature of support MSI-X interrupt and system hibernation.

3. Support new adapters ARC12x4 series.

4. Simplify and unify code for readability and consistency.

Regards,
Ching<ching2048@areca.com.tw>
