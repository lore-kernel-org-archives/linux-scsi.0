From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Sat, 18 Nov 2006 00:36:59 +0100
Message-ID: <455E479B.5030605@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:41626 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1752803AbWKQXhC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 18:37:02 -0500
In-Reply-To: <455E4703.3080005@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joern Quillmann <q-man@gmx.de>
Cc: linux-scsi@vger.kernel.org

I wrote:
> FWIW, sbp2 in Linux 2.6.19-rcX sets the allow_restart flag for all HDDs
> and other direct access devices. In Linux 2.6.18 it does so only for
> Maxtor disks.

Maxtor enclosures that is (not other FireWire enclosures with Maxtor
drives).
-- 
Stefan Richter
-=====-=-==- =-== =--=-
http://arcgraph.de/sr/
