From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/7] scsi_dh: Move hardware handlers from dm to
	SCSI
Date: Tue, 01 Apr 2008 15:51:33 -0700
Message-ID: <20080401225133.2124.62025.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello,

Set of patches that follow this email facilitate movement of hardware
handlers from dm layer to SCSI layer.

Previous set of patches that implemented this was posted on Mar 10:
http://marc.info/?l=dm-devel&m=120519925915390&w=2

Changes have been made based on (1)test results from Dave and
(2)discussions with Jens and James:
 - Make sure scsi_dh compiles as a modules when scsi is compiled as a
   module.
 - Set REQ_QUIET flag in the request in rdac hardware handler's prep_fn,
   if the path is the passive path (to reduce the extraneous error
   messages).
 
Patches are created on top of 2.6.25-rc5-mm1.

Testing has been done with the following storage devices:
 - IBM DS4800 storage device for the lsi_rdac hardware handler
 - HP storage device for the hp_sw hardware handler.
   Thanks to Dave(dwysocha@redhat.com)
 - EMC storage device for the EMC hardware handler.
   Thanks to Arthur(Benoit_Arthur@emc.com) and Ronald(asson_ronald@emc.com)
In effect all hardware handlers are tested.

Thanks,

chandra


-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
