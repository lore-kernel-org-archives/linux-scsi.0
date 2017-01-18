From: Cathy Avery <cavery@redhat.com>
Subject: [PATCH 0/2] scsi: Create a lightweight FC Transport option for
 Virtual FC Hosts.
Date: Wed, 18 Jan 2017 15:28:56 -0500
Message-ID: <1484771338-8903-1-git-send-email-cavery@redhat.com>
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
To: kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Currently virtual FC hosts or lightweight hosts are not able to be
manually scanned  via sysfs due to the fact that they do not
contain the complete characteristic set associated with a normal FC host
( missing rports, vports, etc ) and are not consistent with the current FC
transport model.

Patch 1: The patch provides a lightweight option to the current FC 
transport class. The new option is selected by a driver when it 
indicates it wants the lightweight transport in fc_function_template.

Patch 2: storvsc elects using the new lightweight FC host option.

Cathy Avery (2):
  scsi: scsi_transport_fc: Provide a lightweight option for Virtual FC
    Hosts.
  scsi: storvsc: Add support for FC lightweight host.

 drivers/scsi/scsi_transport_fc.c | 125 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/storvsc_drv.c       |   6 +-
 include/scsi/scsi_transport_fc.h |   1 +
 3 files changed, 123 insertions(+), 9 deletions(-)

-- 
2.5.0
