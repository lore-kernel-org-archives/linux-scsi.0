From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.2.2
Date: Mon,  7 Jun 2004 16:43:46 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1086619426.40c47f220de01@imp5-q.free.fr>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr> <1086256342.40bef4d61b3e9@imp3-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1086256342.40bef4d61b3e9@imp3-q.free.fr>
To: dm-devel@redhat.com
Cc: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.2.2

Major changes are :
1) get a real parser. so update the config file with provided sample
2) get rid of most fixed-size arrays in favor of resizable vectors

All in all, the code base now seems pretty sane.

Changelog for this release :

2004-06-07 multipath-tools-0.2.2
        * [multipath] leave out 2.4 compat code. Is there
          interest anyway ?
        * [multipath] convert all_paths table to vector api.
          Rename to pathvec. Get rid of max_devs
        * [multipath] convert mp table to vector api
        * convert blacklist to vector api
        * 2.6.7-rc? adds _user annotations to scsi/sg.h, causing
          compilation breakage. Add a "#define _user" in all
          sg_include.h (and remove cruft)
        * merge a real parser (from keepalived) courtesy of 
          Alexandre Cassen. Now multipath and multipathd share a
          config file. This comes with a nice vector lib.
        * devnode blacklist moved from hardcoded to config file
        * Guy Coates noted -O2 CFLAGS lead to multipathd crashes
          on IA64. Remove the needless optimisation for now.

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui
-- 
