From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Tue, 2 Oct 2007 16:59:59 -0500
Message-ID: <20071002215959.GM4338@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org> <20070927233437.GF18686@austin.ibm.com> <20071001201247.GN12049@parisc-linux.org> <20071001224132.GH4338@austin.ibm.com> <20071002012730.GO12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:59917 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXJBWAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 18:00:05 -0400
Content-Disposition: inline
In-Reply-To: <20071002012730.GO12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Mon, Oct 01, 2007 at 07:27:30PM -0600, Matthew Wilcox wrote:
> 
> Fine by me.  Do you have the ability to produce failures on a whim on
> your platforms?  

Yes, although it is very platform specific -- there are actually
transistors in the pci bridge chip, which actually short out lines,
and so, from the point of view of the rest of the chip, it did
actually see a "real" error. Its supposed to be a very realistic 
test.

> I've been vaguely musing a PCI device failure patch for
> x86, just so people can test driver failure paths.

That would be good ... I've recently agreed to accept a fedex
to test someone elses card for them, which is outside my usual
activities.

There's also supposed to be some PCI-X riser card out there, 
(never seen one) which has the ability to inject actual pci 
errors. Its the Agilent PCI BestX card; I got the impression 
they might not sell it anymore; dunno.

One guy in the lab used to brush a grounding strap across
the pins; this usually got a rise out of the audience.

--linas

