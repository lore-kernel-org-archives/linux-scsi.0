From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.1 0/16] arcmsr: bugfix and support new adapters ARC12x4
 series
Date: Mon, 05 May 2014 16:32:15 +0800
Message-ID: <1399278735.18695.16.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


This patch series addresses following issues with arcmsr drivers.

1. Bugfix for command timeout, abort, and ioctl error.

2. Add new feature of support MSI-X interrupt and system hibernation.

3. Support new adapters ARC12x4 series.

4. Simplify and unify code for readability and consistency.

These patched have been compile-tested and running-tested OK.

Regards,
Ching<ching2048@areca.com.tw>
