From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] fcoe: Fibre Channel over Ethernet
Date: Fri, 6 Feb 2009 11:13:01 -0800
Message-ID: <20090206111301.67ddac2d.akpm@linux-foundation.org>
References: <20081209231005.17830.92133.stgit@fritz>
	<20081209231024.17830.97893.stgit@fritz>
	<20090204182441.4a8def70.akpm@linux-foundation.org>
	<1233947117.7785.5.camel@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753458AbZBFTOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2009 14:14:06 -0500
In-Reply-To: <1233947117.7785.5.camel@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jgarzik@redhat.com, davem@davemloft.net, james.smart@emulex.com, michaelc@cs.wisc.edu, jeykholt@cisco.com, andi@firstfloor.org, jeffrey.t.kirsher@intel.com, Randy Dunlap <randy.dunlap@oracle.com>

On Fri, 06 Feb 2009 11:05:17 -0800
Robert Love <robert.w.love@intel.com> wrote:

> > The kerneldoc comments consistently close with
> > 
> > **/
> > 
> > which is consistently unconventional.  Not wrong, just odd.
> > 
> 
> I did change the kernel-doc function comment blocks to end with '*/',
> since you called it out. I looked at the other comments under
> drivers/scsi/ and most did end in '*/'. However, the
> Documentation/kernel-doc-nano-HOWTO.txt has an example for function
> headers that shows '**/' as the suggested style. Should the kernel-doc
> HOWTO be updated?

I think so - we might as well be consistent about these things.

> Example kernel-doc function comment:
> 
> /**
>  * foobar() - short function description of foobar
>  * @arg1:       Describe the first argument to foobar.
>  * @arg2:       Describe the second argument to foobar.
>  *              One can provide multiple line descriptions
>  *              for arguments.
>  *
>  * A longer description, with more discussion of the function foobar()
>  * that might be useful to those using or modifying it.  Begins with
>  * empty comment line, and may include additional embedded empty
>  * comment lines.
>  *
>  * The longer description can have multiple paragraphs.
>  **/

That's RandyStuff.
