From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Mon, 20 Oct 2003 07:54:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310200754.21984.pbadari@us.ibm.com>
References: <1066265974.16761.426.camel@fuzzy> <20031018082450.A6510@beaverton.ibm.com> <20031018163820.GC18370@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:56005 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262593AbTJTO6A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 10:58:00 -0400
In-Reply-To: <20031018163820.GC18370@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Matthew Wilcox <willy@debian.org>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Saturday 18 October 2003 09:38 am, Matthew Wilcox wrote:
> On Sat, Oct 18, 2003 at 08:24:50AM -0700, Patrick Mansfield wrote:
> > If you have not seen it, Badari's sd patch is in the mm tree:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.0-test7
> >/2.6.0-test7-mm1/broken-out/support-zillions-of-scsi-disks.patch
>
> I hadn't ... it doesn't address expanding the number of partitions or
> the problem that the sd_index_bits array will grow to a huge size.

Yes. I did not want to address expanding the number of partitions issue -
since there is no resolution on it. (to be frank, I am not really interested 
in it - so never looked at).

I address sd_index_bits array problem in a crude way. I made the max number
of disks to support as configurable.

I wanted to make the patch really simple - so that we can make few 
decisions before making too many changes.

All I wanted to do was following:

- support > 256 scsi disks
- for now, maintain backward compatibility with current /dev major/minor
  assignments
- test out any kernel (lowmem bloating) issues.

Thanks,
Badari 
