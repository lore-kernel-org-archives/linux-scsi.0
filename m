From: christophe varoqui <christophe.varoqui@free.fr>
Subject: multipath-tools-0.3.2
Date: Sun, 17 Oct 2004 16:03:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098021787.5433.8.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1097495416.416a73787e0ae@imp1-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.2

This one will need you to upgrade to latest -udm patchset to support the
new path reinstate feature.
Lots of bugfixes from Suse review.

Full ChangeLog for the release :

	* [multipath] add path reinstate logic :
		* if a path is given as multipath arg
		* if the map containing that path already exists
		* if this map is the same as the that would be
		  created by this multipath run
		* THEN reinstate the path
	  multipathd is is thus unchanged, while now supporting
	  reinstate
	* audit and ensafe all sprintf usage
	* [multipath] fix the annoying \n after each dev_t in
	  params string reporting
	* [multipath] print out devmaps in "-v2 -d" mode
	* [kpartx] bump up the params string size (lmb at suse)
	* [kpartx] replace sprintf by snprintf (lmb at suse)
	* [kpartx] initialize some more vars (lmb at suse)
	* [multipath] mp->pg == NULL safety net before calling
	  assemble_map() (for Andy who happen to hit the bug)
	* [multipath] last rampant bug in map CREATE or UPDATE switch
	  logic due to the device alias feature
	* [kpartx] zeroe "struct slice all" (lmb at suse)

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

