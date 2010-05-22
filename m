From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: [ANNOUNCE] multipath-tools 0.4.9
Date: Sat, 22 May 2010 15:34:08 +0200
Message-ID: <1274535248.6881.10.camel@localhost>
Reply-To: christophe.varoqui@opensvc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54611 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0EVNeR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2010 09:34:17 -0400
Received: by wyb29 with SMTP id 29so516657wyb.19
        for <linux-scsi@vger.kernel.org>; Sat, 22 May 2010 06:34:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

Here is a long due multipath-tools release.

Most patches in there are already available in enterprise distributions
package.

The tarball is available on http://christophe.varoqui.free.fr/
My maintainer work on this project is now sponsored by
http://www.opensvc.com and the Nexenta multipath support has been
sponsored by http://www.alyseo.com/

multipath-tools-0.4.9 shortlog :

      * Changes that may require your altering your config file :
              * rename hp_sw hwhandler
              * directio is now the default checker (async)
              * deprecated prio_callout keyword: now use prio/prio_args
              * move bindings file location to /etc
              * add 'max_fds' keyword
              * add 'verbosity' keyword
              * add 'queue_without_daemon' keyword
              * add 'mode', 'uid' and 'gid' keywords
              * add 'fast_io_fail' and 'dev_loss_tmo' keywords
              * add 'checker' keyword as alias to 'path_checker'
      * Features
              * make kpartx deal with more than 256 minor numbers
              * fail/reinstate CLI commands disable/enable path checker
              * support multipath-capable cciss hardware, add cciss_tur
                checker
              * 'show config' output usable as a config file replacemen=
t
              * create read-only multipath if rw try failed
              * care about offlined paths
              * support resizing of multipath maps
              * kpartx removes its loop devices
              * support other load-balancing policies
              * add datacore prioritizer
              * add '-r' multipath arg to force maps reload
              * add "show paths format" cli command
              * add "show maps format" cli command
              * add "show status" cli command
              * add "show wildcards" cli command
              * add "quit" cli command
              * add "enablequeueing" and "disablequeueing" cli commands
      * Fixes
              * leaks plugged (virtualiron, suse, redhat work)
              * honour ALUA preference indicator
      * Developers changes :
              * no more prioritizer callouts. replaced by mem-pinned .s=
o
                to avoid having to cache the callouts.
              * move checkers to mem-pinned .so too
              * allow arguments passing to prioritizers
      * Contributors :
              * Alex Zeffertt <...@eu.citrix.com>
              * Andrey Panin <...@pazke.donpac.ru>
              * Babu Moger <...@lsi.com>
              * Benjamin Marzinski <...@redhat.com>
              * Brian King <...@linux.vnet.ibm.com>
              * Bryn M.Reeves <...@redhat.com>
              * Chandra Seetharaman <...@us.ibm.com>
              * Charlie Brady <...@budge.apana.org.au>
              * Chauhan, Vijay <...@lsi.com>
              * Christophe Varoqui <...@opensvc.com>
              * Colin Watson <...@canonical.com>
              * Dave Wysochanski <...@redhat.com>
              * Guido Guenther <...@sigxcpu.org>
              * Guido G=C3=83=C2=BCnther <...@sigxcpu.org>
              * Hannes Reinecke <...@suse.de>
              * Jim Lester <...@compellent.com>
              * Kiyoshi Ueda <...@ct.jp.nec.com>
              * Konrad Rzeszutek <...@virtualiron.com>
              * Martin Petermann <...@linux.vnet.ibm.com>
              * Matthew Kent <...@bravenet.com>
              * Mike Anderson <...@linux.vnet.ibm.com>
              * Mike Snitzer <...@redhat.com>
              * Moger, Babu <...@lsi.com>
              * Nikanth Karthikesan <...@suse.de>
              * Ritesh Raj Sarraf <...@researchut.com>
              * Rumko <...@gmail.com>
              * Stefan Bader <...@de.ibm.com>
              * Stefan Haberland <...@de.ibm.com>
              * Stefan Weinhuber <...@de.ibm.com>
              * Yanqing Liu <...@dell.com>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
