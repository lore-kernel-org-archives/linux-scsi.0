From: christophe.varoqui@free.fr
Subject: [dm-devel] [ANNOUNCE] multipath-tools-0.2.5
Date: Wed,  7 Jul 2004 17:12:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089213139.40ec12d3a447b@imp2-q.free.fr>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr> <1086256342.40bef4d61b3e9@imp3-q.free.fr> <1086619426.40c47f220de01@imp5-q.free.fr> <1087209011.40cd7e338ca44@imp5-q.free.fr> <1088441934.40e04e4ebe7e8@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1088441934.40e04e4ebe7e8@imp1-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>, christophe.varoqui@free.fr
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.2.5

includes quite important bugfixes noted by Andy "genanr" on multipathd and
strict EVPD parser from Hannes Reinecke.

Changelog for this release :
 
        * [multipathd] fix misbehaviour noted by genanr @ emsphone . com
	  improper tar directive in Makefile on some systems
	* [multipathd] fix bug noted by genanr @ emsphone . com
	  get_devmaps fills a private vector and forget to pass its
	  address to caller
	* [multipath] extend EVPD 0x83 id fetching logic.
	  Code borrowed from scsi_id (thanks goes to Patrick
	  Mansfield @IBM) and merged by Hannes Reinecke @SUSE
	* [multipathd] fix regression noted by genanr @ emsphone.com
	  (segfault when no config file)

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui
