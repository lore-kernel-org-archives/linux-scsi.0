From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.2.4
Date: Mon, 28 Jun 2004 18:58:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088441934.40e04e4ebe7e8@imp1-q.free.fr>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr> <1086256342.40bef4d61b3e9@imp3-q.free.fr> <1086619426.40c47f220de01@imp5-q.free.fr> <1087209011.40cd7e338ca44@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1087209011.40cd7e338ca44@imp5-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.2.4

Changelog for this release :
 
2004-06-28 multipath-tools-0.2.4
        * [multipathd] break free from system's libsysfs for now
          as it is not that common these days
        * [multipath] introduce per LUN policies in the config
          file : path_grouping_policy, path_selector and
          path_selector_args are supported.
          See updated sample config file.
        * [multipath] move ->iopolicy to multipath struct (from
          path struct)
        * [multipath] fill the voids left in the config file with
          defaults
        * [multipath] group config & flags in a global struct *
        * [multipath] fix segfault when no config file (was a 
          regression since hwtable vectorisation in 0.2.2)
        * [multipath] default path selector override in config file
        * [multipath] don't play with strings in pgpolicies, leave
          that to a new assemble_map fn. policies now use vectors
        * [multipathd] compilation fix for gentoo (Franck Denis)
        * [multipath] strcmp fix (Franck Denis)

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui
