From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.3.9
Date: Sun, 05 Dec 2004 16:43:12 +0100
Message-ID: <1102261392.29843.2.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
	 <1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	 <1101394541.5820.71.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.wanadoo.fr ([193.252.22.26]:60361 "EHLO smtp5.wanadoo.fr")
	by vger.kernel.org with ESMTP id S261199AbULEPnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Dec 2004 10:43:14 -0500
In-Reply-To: <1101394541.5820.71.camel@zezette>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

here goes multipath-tools-0.3.9

This release implements the new kernel multipath policies : 
      * no table reload when possible 
      * use of "switch_group" and "reinstate_path" DM messages instead

A much improved and informational output format too.
And a new '-l' flag to list current multipath topology 

Full ChangeLog for the release :

        * [multipath] add a "-l" flag to list the current
          multipath maps and their status info
        * [priority] zalloc controler to avoid random path_count
          at allocation time
        * [multipath] add configlet pointers in struct multipath
          to avoid searching for an entry over and over again
        * [multipath] new reinstate policy : on multipath exec,
          reinstate all failed paths the checkers report as ready
          if they belong to enabled path groups (not disabled, not
          active path group)
        * [multipath] fork a print_mp() out of print_all_mp()
        * [multipath] introduce PG priority, which is the sum of
          its path priorities. Set first_pg in the map string to
          the highest prio PG index.
        * [multipath] assemble maps scaning PG top down now that
          PG vector is unsorted
        * [multipath] move select_*() to propsel.c
        * [multipath] move devinfo() to devinfo.c
        * [multipath] move h/b/t/l fetching to sysfs_devinfo()
        * [multipath] move devt2devname() to devinfo.c so we can
          use it from dmparser.c too
        * [multipath] introduce select_alias() and clarify a bit
          of code
        * [multipath] don't sort PG anymore. We want the map as
          static as possible.
        * [multipath] fix a segfault in apply_format() triggered
          when no config file found.
        * [multipath] kill unused vars all over the place
        * [multipath] add a struct pathgroup in struct multipath
          Store the pathvec in it. We now have a place to store
          PG status, etc ...
        * [multipath] new dmparser.c, with disassemble_map(),
          disassemble_status()
        * [multipath] suppress *selector_args keywords. Merge
          in the selector string. Update config file templates.

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>


