From: Kurt Miller <kurt@intricatesoftware.com>
Subject: Re: LSI SAS2008 SATA TRIM not working
Date: Tue, 11 Feb 2014 21:27:30 -0500
Message-ID: <1392172050.2761.37.camel@sonic.justonedata.com>
References: <1391730975.3449.16.camel@sonic.justonedata.com>
	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>
	 <1391806363.2761.8.camel@sonic.justonedata.com>
	 <yq1mwi2skoz.fsf@sermon.lab.mkp.net>
	 <1391808293.2761.9.camel@sonic.justonedata.com>
	 <yq1iosqs8fx.fsf@sermon.lab.mkp.net>
	 <1391984895.13523.13.camel@tardis.intricatesoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 4133fa24.cst.lightpath.net ([65.51.250.36]:7716 "EHLO
	mail1.intricatesoftware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179AbaBLC2V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 21:28:21 -0500
In-Reply-To: <1391984895.13523.13.camel@tardis.intricatesoftware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

I can report that the Samsung 840 Pro *does* support trim on the LSI
SAS2008. As suspected it supports deterministic read zeros after trim.

One other thing to note, in my testing the P16 LSI firmware has broken
trim support. P14 and P15 report incorrect values for
/sys/block/sdX/queue/discard_granularity. P17 and P18 appear to work
fine and report correct values for discard_granularity.

-Kurt

