From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 07:56:46 +0200
Message-ID: <4714529E.6080002@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:34073 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058AbXJPF5m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 01:57:42 -0400
In-Reply-To: <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

david@lang.hm wrote:
> On Mon, 15 Oct 2007, Stefan Richter wrote:
>> Low-level networking drivers suggest a default interface name (per
>> interface or as a template like eth%d into which the networking core
>> inserts a lowest spare number).
...
>> Could low-level SCSI drivers provide similar name templates which give a
>> hint on the transport involved?
...
> one other option that could be considered (and I do realize I'm bringing
> up flame-bait here) is that drivers that have fixed addresses could
> offer up a device name that include that address.
...

That's already implemented. :-) Transport drivers expose transport
specific information in sysfs; udev scripts examine it and create by-id
and by-path symlinks to device files of HDDs.  Not everybody agrees, but
many think that it's sensible to implement just mechanism in kernel and
leave policy to userspace.  My suggestion and the default network
interface names already violate this principle to a degree, but it can
still be implemented in a transport independent way, and userspace can
continue to create whatever names the user needs.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
