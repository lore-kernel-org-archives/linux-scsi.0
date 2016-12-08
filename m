From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi: scsi: scsi_devinfo: remove
	synchronous ALUA for NETAPP devices
Date: Thu,  8 Dec 2016 11:04:16 -0800 (PST)
Message-ID: <20161208190416.96B7B8EE276@bedivere.hansenpartnership.com>
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
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Martin George <Martin.George@netapp.com>, Hannes Reinecke <hare@suse.de>, SCSI ML <linux-scsi@vger.kernel.org>, Robert Stankey <Robert.Stankey@netapp.com>, Sean Stewart <sean.stewart@netapp.com>, Steven Schremmer <Steven.Schremmer@netapp.com>martin.petersen@oracle.com, Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>, Sean Stewart <Sean.Stewart@netapp.com>, James.Bottomley@hansenpartnership.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: scsi_devinfo: remove synchronous ALUA for NETAPP devices
    
    NetApp did confirm this is not required.
    
    Cc: Martin George <Martin.George@netapp.com>
    Cc: Robert Stankey <Robert.Stankey@netapp.com>
    Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
    Cc: Sean Stewart <Sean.Stewart@netapp.com>
    Cc: Hannes Reinecke <hare@suse.de>
    Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Reviewed-by: Sean Stewart <sean.stewart@netapp.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "misc"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=9c58b395563b15866c9fd9bb7e6f7f8db12ac3ae

This patch is scheduled to be pushed when the merge window opens for 4.10

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
