From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/7] scsi_dh: Move hardware handlers from dm to
	SCSI
Date: Thu, 17 Apr 2008 15:22:45 -0700
Message-ID: <20080417222245.26477.49142.sendpatchset@chandra-ubuntu>
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
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

NOTE: This is a resend (again) of the patchset sent on Apr 15 as it did not
reach linux-scsi mailing list

Hello,

This is the same set of patches that was posted on Apr 01:
http://marc.info/?l=dm-devel&m=120716401627550&w=2

Only change is that these patches are created on top of 2.6.25-rc8-mm2.

Testing has been done with the following storage devices:
 - IBM DS4800 storage device for the lsi_rdac hardware handler
 - HP storage device for the hp_sw hardware handler.
   Thanks to Dave(dwysocha@redhat.com)
 - EMC storage device for the EMC hardware handler.
   Thanks to Arthur(Benoit_Arthur@emc.com) and Ronald(asson_ronald@emc.com)
In effect all hardware handlers are tested.

These patches need an ACK from Alasdair(agk@redhat.com).

Thanks,

chandra
