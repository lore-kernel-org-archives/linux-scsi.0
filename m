From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 18:52:17 -0400
Message-ID: <yq1tz0fe0ym.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org>
	<yq17hxbfvf9.fsf@sermon.lab.mkp.net> <4A8096EF.6010508@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:25774 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZHJWxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 18:53:32 -0400
In-Reply-To: <4A8096EF.6010508@interlog.com> (Douglas Gilbert's message of
	"Mon, 10 Aug 2009 17:53:51 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> It would be interesting to know if Windows 7 is pushing UAS (USB
Doug> attached SCSI) [latest draft at www.t10.org is uas-r02.pdf].

I'll see what I can dig up...

In any case UAS is a transport class.  Sure, it would provide us with
another "can't-be-completely-brain-dead" heuristic.  But we're still at
the firmware writer's whim when it comes to SPC/SBC-level commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
