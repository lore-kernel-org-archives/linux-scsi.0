From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.3.7
Date: Fri, 12 Nov 2004 00:10:16 +0100
Message-ID: <1100214617.10251.92.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
	 <1099328918.5525.10.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <1099328918.5525.10.camel@zezette>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.7

Resync before commencing adjusting for new kernel driver rules.
Note, the default build is now "glibc" to ease packagers work.
Important bugfixes from Suse.

Full ChangeLog for the release :

	* [libmultipath] make the config file parser play nice
	  with the stack (Hannes, Suse)
	* [multipathd] fix off by one memory allocation (Hannes,
	  Suse)
	* [multipathd] introduce a default callout handler that
	  just remembers to put the callout in ramfs, even if the
	  daemon has no direct use of them. multipath need some
	  that where forgotten, so parse them and use that default
	  handler.
	* [libcheckers] emc_clariion checker update (heinz, Suse)
	* [build] exit build process on failure (heinz, Suse)
	* [kpartx] exit early if DM prereq not met
	* [multipath] exit early if DM prereq not met
	* [libmultipath] new dm_prereq() fn to check out if all DM
	  prerequisites are met
	* [libmultipath] move callout.[ch] function in there.
	  multipath and multipathd impacted
	* [libmultipath] move dm_* function in there. kpartx,
	  multipath are impacted
	* [priority] pp_balance_lun should use DM_DEVICE_TABLE ioctl
	  instead of DM_DEVICE_STATUS to find out paths from the
	  primary path groups.
	* [klibc] drop in "Stable" version 0.190
	* [build] add manpages for kpartx and multipathd (Patrick
	  Caulfield)
	* [build] use system's sysfs for multipathd linking
	* [build] make glibc the default build
	* [build] "make BUILD=klibc" is enough, deprecate the 
	  "make BUILD=klibc klibc" synthax

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>



-------------------------------------------------------
This SF.Net email is sponsored by:
Sybase ASE Linux Express Edition - download now for FREE
LinuxWorld Reader's Choice Award Winner for best database on Linux.
http://ads.osdn.com/?ad_id=5588&alloc_id=12065&op=click
