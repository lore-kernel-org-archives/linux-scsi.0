From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH v3 0/2] scsi: storvsc: Add support for FC rport
Date: Mon, 17 Apr 2017 14:37:44 -0400
Message-ID: <1492454266-24587-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@infradead.org
Cc: devel@linuxdriverproject.org, haiyangz@microsoft.com, sthemmin@microsoft.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The updated patch set provides a way for drivers ( specifically
storvsc in this case ) that expose virturalized fc devices
but that do not expose rports to be manually scanned. This is
done via creating a pseudo rport in storvsc and a
corresponding dummy initiator rport role in the fc transport.

Changes since v2:
- Additional patch adding FC_PORT_ROLE_FCP_DUMMY_INITIATOR role
  to fc_transport
- Changed storvsc rport role to FC_PORT_ROLE_FCP_DUMMY_INITIATOR

Changes since v1:
- Fix fc_rport_identifiers init [Stephen Hemminger]
- Better error checking


Cathy Avery (2):
  scsi: scsi_transport_fc: Add dummy initiator role to rport
  scsi: storvsc: Add support for FC rport.

 drivers/scsi/scsi_transport_fc.c | 10 ++++++----
 drivers/scsi/storvsc_drv.c       | 23 ++++++++++++++++++-----
 include/scsi/scsi_transport_fc.h |  1 +
 3 files changed, 25 insertions(+), 9 deletions(-)

-- 
2.5.0
