From: Fam Zheng <famz@redhat.com>
Subject: [PATCH v2 0/2] virtio-scsi: Implement FC_HOST feature
Date: Thu, 26 Jan 2017 11:41:07 +0800
Message-ID: <20170126034109.16144-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

v2: Fix endianness of WWNN/WWPN. [Paolo]

This series implements the proposed fc_host feature of virtio-scsi.

The first patch updates the data structure changes according to the spec
proposal; the second patch actually implements the operations.

Fam Zheng (2):
  virtio_scsi: Add fc_host definitions
  virtio_scsi: Implement fc_host

 drivers/scsi/virtio_scsi.c       | 60 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_scsi.h |  6 ++++
 2 files changed, 65 insertions(+), 1 deletion(-)

-- 
2.9.3
