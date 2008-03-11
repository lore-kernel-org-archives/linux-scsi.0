From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/7] scsi_dh: Move hardware handlers from dm to
	SCSI
Date: Mon, 10 Mar 2008 18:33:28 -0700
Message-ID: <20080311013328.23179.76692.sendpatchset@localhost.localdomain>
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
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello,

Set of patches that follow this email facilitate movement of hardware
handlers from dm layer to SCSI layer.

Previous set of patches that implemented this was posted on Feb 27:
http://marc.info/?l=linux-scsi&m=120416126328081&w=2

Changes have been made based on feedback received from James and Mike
Anderson.

Following are the changes:
 - Reduced the number of pointers used in scsi_device data structure
   from 2 to 1.
 - Added a special return code for check_sense function to return when
   the sense code is not handled by hardware handler's check_sense fucntion.
 - Added a request pointer argument to hardware handler's prep_fn.
 
Patches are created on top of 2.6.25-rc2-mm1.

Testing has been done with a IBM DS4800 storage device, which means the
infrastructure and the lsi_rdac hardware handler has been tested. Testing
by someone with the EMC hardware and/or HP hardware would be appreciated.

Comments, suggestions solicited.

Thanks,

chandra


-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
