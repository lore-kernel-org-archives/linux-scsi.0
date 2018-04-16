From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi: scsi: scsi_dh: replace too broad
	"TP9" string with the exact models
Date: Mon, 16 Apr 2018 00:25:41 -0700 (PDT)
Message-ID: <20180416072541.7BE5F8EE25E@bedivere.hansenpartnership.com>
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
To: SCSI ML <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, DM ML <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: scsi_dh: replace too broad "TP9" string with the exact models
    
    SGI/TP9100 is not an RDAC array:
        ^^^
    https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c;h=88b4700beb1d8940008020fbe4c3cd97d62f4a56;hb=HEAD#l235
    
    This partially reverts commit 35204772ea03 ("[SCSI] scsi_dh_rdac :
    Consolidate rdac strings together")
    
    [mkp: fixed up the new entries to align with rest of struct]
    
    Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: DM ML <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "misc"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=72001a0bfb365cf147e1317ab482dd760cb5d120

This patch is scheduled to be pushed when the merge window opens for 4.18

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
