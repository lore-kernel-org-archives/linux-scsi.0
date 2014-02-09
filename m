From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Sun, 09 Feb 2014 17:28:15 -0500
Message-ID: <1391984895.13523.13.camel@tardis.intricatesoftware.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>
	 <1391806363.2761.8.camel@sonic.justonedata.com>
	 <yq1mwi2skoz.fsf@sermon.lab.mkp.net>
	 <1391808293.2761.9.camel@sonic.justonedata.com>
	 <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:15546 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbaBIW22 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2014 17:28:28 -0500
In-Reply-To: <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2014-02-07 at 20:24 -0500, Martin K. Petersen wrote:
> >>>>> "Kurt" == Kurt Miller <kurt@intricatesoftware.com> writes:
> 
> Kurt> #  hdparm -I /dev/sdc
> 
> [...]
> 
> I don't see any deterministic read after trim/read zero after trim
> support on your drive. And I have a sneaking suspicion that those are
> two of the fields that the LSI firmware looks at when deciding whether
> to support logical block provisioning (in addition to support for the
> DSM TRIM command).
> 

I wonder how to bring this issue to LSI's attention? My cross flashed
used controllers are out of support with LSI so I don't think I can get
them to listen to me.

>From a pricing perspective the Samsung 840 Pro looks interesting and is
on LSI's supported list. Does anyone have one of these around and can
check for deterministic read after trim? (hdparm -I /dev/sdc | grep
TRIM).

Thanks,
-Kurt

