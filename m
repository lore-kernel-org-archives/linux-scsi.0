From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools 0.4.7
Date: Mon, 13 Mar 2006 15:14:19 +0100
Message-ID: <20060313141419.GE6902@pundit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crn60-1-82-233-169-3.fbx.proxad.net ([82.233.169.3]:6347 "EHLO
	pundit") by vger.kernel.org with ESMTP id S1750849AbWCMOSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Mar 2006 09:18:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org

Hello,

Here comes multipath-tools 0.4.7.

This release is a milestone : the daemon is progressively taught to overtake all the work done by the multipath configurator in the previous releases. To that end, the daemon CLI syntax is being vastly extended.


2006-03-13 multipath-tools-0.4.7 shortlog :

    * multipathd empowering
          o DM driving directly from the daemon, without resorting to multipath(8)
          o udev rules deprecation, as events are acted upon directly through uevent in the daemon. The kpartx rule remains though
    * multipathd CLI commands
          o enh : the CLI parser now accept unambiguous shortcuts, like "sho topo" for "show topology"
          o new : "show config" drops a config file as seen by the live daemon
          o new : "show maps stats" drops some statistics about multipaths events
          o new : "show topology", mimics the "multipath -ll" output
          o new : "show map $map topology", mimics the "multipath -ll $map" output
          o enh : "reconfigure" correctness issues fixed, scope extended
          o enh : "add/del map" now apply to the DM live configuration too (!!caution, maps are really removed!!)
          o rem : "dump pathvec", deprecated
    * prioritizers
          o new : netapp prioritizer
          o new : tpc prioritizer (SGI, ...)
    * netlink uevent robustness
          o bigger receive buffer
          o uevent queueing and async dequeueing
    * configuration
          o rr_min_io can be put in "device" and "multipath" config blocks
          o internal defaults are now exhaustive
          o tweak defaults for HP, SGI, IBM, EMC, ...
    * multipaths renaming through DM renames rather than remove/add cycles
    * logging
          o "multipathd -d" now prints the date
          o overall output beautifying
    * drop the "path cache" framework
    * kpartx
          o fixes to dos partition handler
          o new mac partition handler
    * make the tools work with DASD
    * blacklist
          o add per-device product-string blacklist
          o add a device blacklist
          o add a wwid blacklist
          o deprecate the "devnode_blacklist" keyword ub favor of "blacklist"
    * adapt to libsysfs2 api, without breaking compat with libsysfs1
    * checkers
          o API rewrite
          o reduce allocation on the directio checking code path

As usual, the tarball can be downloaded at http://christophe.varoqui.free.fr/multipath-tools/multipath-tools-0.4.7.tar.bz2
Documentation and general information at http://christophe.varoqui.free.fr

Regards,
cvaroqui
