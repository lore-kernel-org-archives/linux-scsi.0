From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.3.5
Date: Tue, 26 Oct 2004 12:06:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098785191.417e21a7a7c28@imp1-q.free.fr>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette> <1098269169.417641f18a234@imp1-q.free.fr> <1098656088.9350.88.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098656088.9350.88.camel@zezette>
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.3.5

As expected, 0.3.4 was still cutting at the edges, so this is a bugfix oriented
release. Thanks for the feedback so far.

Note the changes to udev config files : they need updating
Note the unproven 2.6.10-rc1+ new dependency for SG_IO ioctl on bdevs.

Full ChangeLog for the release :

	* [multipathd] fix broken test for path going up or shaky
	  that kept executing multipath when it shouldn't
	* change multipath.dev to exit early when udev' DEVNAME is
	  a devmap (/dev/dm-*). This avoids a recursion case when
	  the kernel devmapper keeps removing a map after multipath
	  configures it.
	* change multipath.rules to follow the new -D synthax
	* [multipath] "-D major minor" synthax changed to
	  "-D major:minor" to match the sysfs attribute value.
	  This change removes a few translations in multipath and
	  multipathd.
	* [multipath] fix segfault in test if conf->dev is a devmap
	  (the one forwarded by MikeAnd)
	* SG_IO ioctl seem to work in lk 2.6.10+, so remove all sg
	  device knowledge and advertise (here) the new dependency.
	* [multipath] remove unused do_tur()
	* [multipath] fix sort_pg_by_summed_prio(), and don't add up
	  failed path priority

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
--
christophe varoqui <christophe.varoqui@free.fr>
