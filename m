From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spinup of SCSI Disks: allow_restart won't work on 2.6.18
Date: Mon, 20 Nov 2006 12:48:33 +0100
Message-ID: <45619611.5020502@s5r6.in-berlin.de>
References: <455DF39A.6090209@fbihome.de> <455E2D44.5030903@gmx.de> <455E4703.3080005@s5r6.in-berlin.de> <456188FD.3020108@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:52637 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S933670AbWKTLse (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 06:48:34 -0500
In-Reply-To: <456188FD.3020108@fbihome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joern Quillman <quillman@fbihome.de>
Cc: linux-scsi@vger.kernel.org

Joern Quillman wrote:
> One problem left. I still can't set or unset the flag with echo even on 
> 2.6.19-rc6 (as root). Always getting a write error. Not that I care much 
> about this, 'cause I for sure don't want it disabled.
> But it's strange nonethless.

But the attribute has write permission set? (ls -l)
It is writable on the last kernel I tried, which is -rc4.
-- 
Stefan Richter
-=====-=-==- =-== =-=--
http://arcgraph.de/sr/
