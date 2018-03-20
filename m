From: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Patch added to scsi: scsi: devinfo: remove dasd devices
	from the scsi subsystem
Date: Tue, 20 Mar 2018 15:54:12 -0700 (PDT)
Message-ID: <20180320225412.C56548EE4F1@bedivere.hansenpartnership.com>
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
To: Takahiro Yasui <takahiro.yasui@hitachivantara.com>, device-mapper development <dm-devel@redhat.com>, James.Bottomley@hansenpartnership.com, Anthony Cheung <anthony.cheung@hpe.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, s390 ML <linux-s390@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

Your commit:

    scsi: devinfo: remove dasd devices from the scsi subsystem
    
    Only present through ccw bus.
    
    [mkp: applied by hand]
    
    Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
    Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
    Cc: Anthony Cheung <anthony.cheung@hpe.com>
    Cc: Mike Christie <mchristi@redhat.com>
    Cc: Martin K. Petersen <martin.petersen@oracle.com>
    Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
    Cc: s390 ML <linux-s390@vger.kernel.org>
    Cc: SCSI ML <linux-scsi@vger.kernel.org>
    Cc: device-mapper development <dm-devel@redhat.com>
    Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

has been added to the upstream scsi tree
On branch "misc"
You can find it here:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=b40c2025fdb62b8feeff1ab5e09a8f508d052299

This patch is scheduled to be pushed when the merge window opens for 4.17

James Bottomley

P.S. If you find this email unwanted, set up a procmail rule junking on
the header:

X-Git-Tree: SCSI
