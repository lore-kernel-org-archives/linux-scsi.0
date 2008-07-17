From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/8] scsi_dh update
Date: Thu, 17 Jul 2008 16:52:45 -0700
Message-ID: <20080717235245.23056.89788.sendpatchset@chandra-ubuntu>
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
To: James.Bottomley@HansenPartnership.com, hare@suse.de, linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hi James, Hannes,

These are the same set of patches that Hannes sent early this morning with the 
prelog below.

I just ported it to compile clean on top of 2.6.26-git6.

Made 3 additional changes:
 1. Added a break under MODE_SELECT option in function get_req() (in 3/8)
 2. Added the ifndef portion for scsi_dh_attach() and scsi_dh_detach (in 6/8)
 3. Moved the definition of SCSI_DH_DEV_UNSUPP from 6/8 to 3/8.

regards,

chandra
------ Here is the 0/8 from Hannes's original patchset. -----------

Hi James,

this is the (hopefully final) update to my scsi_dh patchset.
Features are:

- Move device-table matching into the device_handler infrastructure,
 so that individual drivers don't have to implement it themselves
- Adds a 'dh_state' sysfs attribute for manually attaching device
 handler to new or unknown disks; this allows to override the
 internal device tables
- Update the dm-multipath code to attach the device handler
 specified in the multipath configuration
- Add a cache to speed up lookup of several identical devices
- Update existing EMC, RDAC, and hp_sw device handler to use
 the new infrastructure
- Add new SPC-3 ALUA device handler

The NetApp device handler has been left out for now as it's still
under development.

Please apply.

Cheers,

Hannes
--------------------------------------------------------------------
