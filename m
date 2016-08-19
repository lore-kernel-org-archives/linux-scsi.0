From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi: scsi: blacklist all RDAC devices
	for BLIST_NO_ULD_ATTACH
Date: Fri, 19 Aug 2016 07:44:29 -0700 (PDT)
Message-ID: <20160819144430.6A17B8EE197@bedivere.hansenpartnership.com>
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
To: Sean Stewart <Sean.Stewart@netapp.com>, James.Bottomley@hansenpartnership.com, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>martin.petersen@oracle.com, Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: blacklist all RDAC devices for BLIST_NO_ULD_ATTACH
    
    "Universal Xport" LUN is used for in-band storage array management.
    
    Cc: Sean Stewart <Sean.Stewart@netapp.com>
    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Acked-by: Sean Stewart <Sean.Stewart@netapp.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "fixes"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=c6b269ba51be70fd11852bcad2e163c734e8e92a

This patch is scheduled to be pushed for 4.8

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
