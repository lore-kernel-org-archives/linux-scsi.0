From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi: scsi: Replace wrong device handler
	name for CLARiiON arrays
Date: Sun, 16 Oct 2016 14:04:48 -0700 (PDT)
Message-ID: <20161016210448.3823F8EE0E2@bedivere.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>, device-mapper development <dm-devel@redhat.com>, James.Bottomley@hansenpartnership.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, martin.petersen@oracle.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, Hannes Reinecke <hare@suse.de>, SCSI ML <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>"Martin K. Petersen" <martin.petersen@oracle.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: Replace wrong device handler name for CLARiiON arrays
    
    At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
    
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Reviewed-by: Hannes Reinecke <hare@suse.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "fixes"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=0ba43a81ef7b78ddf404f7709a2257be59436411

This patch is scheduled to be pushed for 4.9

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
