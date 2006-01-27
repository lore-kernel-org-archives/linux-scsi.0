From: askernel2615@dsgml.com
Subject: Re: More information on scsi_cmd_cache leak... (bisect)
Date: Fri, 27 Jan 2006 15:02:49 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0601271501300.8977@pureeloreel.qftzy.pbz>
References: <200601270410.06762.chase.venters@clientec.com>
 <17369.65530.747867.844964@cse.unsw.edu.au> <20060127112352.GF4311@suse.de>
 <20060127112837.GG4311@suse.de> <43DA6F33.3070101@cs.wisc.edu>
 <1138389616.3293.13.camel@mulgrave> <43DA787F.4080406@cs.wisc.edu>
 <20060127194927.GB9068@suse.de> <Pine.LNX.4.64.0601271351070.9232@turbotaz.ourhouse>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc14.comcast.net ([204.127.202.59]:41099 "EHLO
	sccrmhc14.comcast.net") by vger.kernel.org with ESMTP
	id S1030326AbWA0UC7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 15:02:59 -0500
In-Reply-To: <Pine.LNX.4.64.0601271351070.9232@turbotaz.ourhouse>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: Jens Axboe <axboe@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org, a.titov@host.bg, jamie@audible.transient.net



On Fri, 27 Jan 2006, Chase Venters wrote:

> On Fri, 27 Jan 2006, Jens Axboe wrote:

>> The reports of leaks are only with > 2.6.15, not with 2.6.15.

> Correction... my leak is with 2.6.15.

Mine is also 2.6.15. Stock with debian patches.

In fact I believe ALL the reports are from 2.6.15.

 	-Ariel
