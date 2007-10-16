From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 08:33:21 +0200
Message-ID: <47145B31.8080104@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com> <4713B58B.9050905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35114 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760993AbXJPGed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 02:34:33 -0400
In-Reply-To: <4713B58B.9050905@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Jeff Garzik wrote:
> Greg KH wrote:
>> On Mon, Oct 15, 2007 at 03:36:15AM -0500, Rob Landley wrote:
>>> The point I was trying to make is that it seems to me like it would
>>> be possible to keep the namespace separate here, and thus reduce the
>>> enumeration problems to the point where common cases (like my laptop)
>>> aren't impacted by them during early boot.
>>
>> Proposals on how to do this would be gladly reviewed.
> 
> Agreed.

  - move the networking core's facilities to build the default name of
    an interface into lib/
  - expand it to optionally use base-26 numbering (a...nn...zzz) as
    alternative to decimal numbering
  - let SCSI low-level drivers optionally provide a short constant
    string, resembling its transport name, in the host template or
    transport template
  - let SCSI high-level driver make use of the new naming functions in
    lib/, providing either just "sd", "sr" etc. or "sd-$transport-" as
    name prefix

No patch yet, and alas I'm currently short of spare time.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
