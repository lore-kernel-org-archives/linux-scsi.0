From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.0
Date: Sun, 12 Dec 2004 18:20:26 +0100
Message-ID: <1102872026.9819.1.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	 <1097054573.4163b96d1262c@imp5-q.free.fr>
	 <1097495416.416a73787e0ae@imp1-q.free.fr> <1098021787.5433.8.camel@zezette>
	 <1098269169.417641f18a234@imp1-q.free.fr>
	 <1098656088.9350.88.camel@zezette>
	 <1098785191.417e21a7a7c28@imp1-q.free.fr>
	 <1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	 <1101394541.5820.71.camel@zezette>  <1102261392.29843.2.camel@zezette>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp7.wanadoo.fr ([193.252.22.24]:34809 "EHLO smtp7.wanadoo.fr")
	by vger.kernel.org with ESMTP id S262088AbULLRU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Dec 2004 12:20:28 -0500
In-Reply-To: <1102261392.29843.2.camel@zezette>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Hello,

here goes multipath-tools-0.4.0

This is bugfix release.
An important checker file descriptor leak fix, and checker context
allocation size fix. 
Don't print unchanged maps anymore and display adaptative human friendly
map size units.


Full ChangeLog for the release :

        * [checkers] forgot to return back to caller the newly
          allocated context. Lead to fd leak notably.
        * [checkers] heavy check logic fix
        * [checkers] really malloc the checker context size,
          not the pointer size (stupidy may kill)
        * [multipathd] check more sysfs calls return values
        * [multipathd] search for sysfs mount point only once,
          not on each updatepaths() iteration
        * [multipathd] plug (char *) leak in the daemon
        * [multipath] change pgcmp logic : we want to reload a
          map only if a path is in computed map but not in cur
          map (ie accept to load a map if it brings more paths)
        * [multipath] undust coalesce_paths()
        * [multipath] don't print unchanged multipath
        * [multipath] store the action to take in the multipath
          struct
        * [multipath] print mp size with kB, MB, GB or TB units
        * [multipath] compilation fix for merge_words() (Andy)
        * [multipath] don't feed the kernel DM maps with paths of
          different sizes : DM fails and we end up with an empty
          map ... not fun
        * [multipath] cover a new corner case : path listed in
          status string but disappeared from sysfs
        * [multipath] remove the "-D" command line flag : now
          we can pass major:minor directly as last argument, like
          device names or device map names. Update multipathd
          accordingly.
        * [multipath] try reinstate again paths after a switchpg
        * [multipath] reinstate condition change :

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>


