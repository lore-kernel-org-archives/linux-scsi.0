From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Notify about errors during initialization
Date: Tue, 6 Jan 2004 11:04:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106190452.GB2119@beaverton.ibm.com>
References: <20040105021047.GD30408@one-eyed-alien.net> <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org> <20040105221302.A7678@infradead.org> <20040105233221.GC1936@beaverton.ibm.com> <20040106161731.A17858@infradead.org> <20040106091538.A10957@beaverton.ibm.com> <20040106171843.A18507@infradead.org> <20040106180814.GA2119@beaverton.ibm.com> <20040106180832.A19009@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:41983 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264604AbUAFTBG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 14:01:06 -0500
Content-Disposition: inline
In-Reply-To: <20040106180832.A19009@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Jan 06, 2004 at 10:08:14AM -0800, Mike Anderson wrote:
> > > Because some drivers (like the ieee1394) don't want scanning to happen.
> > > They can easily chose that by not sending a scan event.
> > > 
> > 
> > Couldn't the user space also set the policy to scan or not scan? It
> > would seem that user space would be more flexible and not need a new
> > api (Just do not call scsi_scan_host).
> 
> For ieee1394 scanning doesn't make any sense, so I don't see why it should
> scan at all.
> 
> And I don't understand that API argument at all.  With my suggestion
> scsi_scan_host would be changed to send the hotplug even - not change in
> API at all.

ok, I was reading two replies back when you mentioned
"scsi_scan_host_parallel". I re-read the last reply and see that
scsi_scan_host would just send a scan event. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

