From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.2.3
Date: Mon, 14 Jun 2004 12:30:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087209011.40cd7e338ca44@imp5-q.free.fr>
References: <1084519750.40a47546dd0e6@imp1-q.free.fr> <1086256342.40bef4d61b3e9@imp3-q.free.fr> <1086619426.40c47f220de01@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:20157 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S262337AbUFNKaN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 06:30:13 -0400
In-Reply-To: <1086619426.40c47f220de01@imp5-q.free.fr>
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.2.3

Changelog for this release :
 
2004-06-14 multipath-tools-0.2.3
        * [multipath] group_by_serial try to be smart with LUN
	  balancing across controlers (for STK / LSI) :
	  1st multipath : 1st pg made of paths through 1st controler
	  2nd multipath : 1st pg made of paths through 2nd controler
	  3rd multipath : 1st pg made of paths through 1st controler
	  ...
	* [multipath] drop .pindex[] in struct multipath in favor
	  of a *paths vector : much cleaner
	* [multipath] fix group_by_serial pgpolicy broken by
	  vectorisation in 0.2.2
	* add a StorageTek and 2 SUN arrays in the sample multipath.conf
	* [multipathd] strcmp fix from 
	* [multipathd] convert to vector api
	* [multipathd] add a configfile option for path checking
	  interval. See sample configfile for synthax.

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui
