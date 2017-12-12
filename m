From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi:  scsi: dh: add new rdac devices
Date: Tue, 12 Dec 2017 08:22:39 -0800 (PST)
Message-ID: <20171212162239.1DB568EE3F7@bedivere.hansenpartnership.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>martin.petersen@oracle.com, Hannes Reinecke <hare@suse.de>, James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: dh: add new rdac devices
    
    Add IBM 3542 and 3552, arrays: FAStT200 and FAStT500.
    
    Add full STK OPENstorage family, arrays: 9176, D173, D178, D210, D220,
    D240 and D280.
    
    Add STK BladeCtlr family, arrays: B210, B220, B240 and B280.
    
    These changes were done in multipath-tools time ago.
    
    Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "misc"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=4b3aec2bbbce1c35f50e7475a9fd78d24b9ea4ea

This patch is scheduled to be pushed when the merge window opens for 4.16

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
