From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 0/5] arcmsr: support areca new adapter ARC1203
Date: Wed, 25 Nov 2015 19:32:06 +0800
Message-ID: <1448451126.4670.25.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Patch 1 fixes getting wrong configuration data.

Patch 2 fixes not release allocated resource if get configuration data
failed.

Patch 3 modifies codes for more readable.

Pacth 4 adds codes to support new adapter ARC1203.

Patch 5 changes driver version number.

--
