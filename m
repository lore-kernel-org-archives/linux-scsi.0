From: Douglas Gilbert <dougg@torque.net>
Subject: Re: PATCH: (as355) Fix test for valid sense data present
Date: Fri, 27 Aug 2004 09:36:33 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412E7401.9080305@torque.net>
References: <Pine.LNX.4.44L0.0408261244430.1089-100000@ida.rowland.org> <1093541269.2326.148.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:17284 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269672AbUHZXhV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 19:37:21 -0400
In-Reply-To: <1093541269.2326.148.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-08-26 at 12:59, Alan Stern wrote:
> 
>>No problems have come up in actual use.  I wrote the patch in response to 
>>the message below, from Douglas Gilbert (this was part of an interchange 
>>commenting on some proposed additions to the 
>>Documentation/scsi/scsi_mid_low_api.txt document -- see the section 
>>about Autosense).  Was he incorrect?
> 
> 
> I suspect that's because you've never seen any of the new types in
> practice.
> 
> 0x70 is really the only sense type we process correctly: Fixed Format. 
> 0x72 is the newer Descriptor Format.  0x71 and 0x73 are the Fixed and
> Descriptor format deferred sense conditions.
> 
> We really only get deferred errors if the device has a cache that is set
> to writeback, so we just hope never to see them...
> 
> I thought Doug had a proposal for unifying our view of Fixed vs
> Descriptor sense formats?

James,
Yes. I'll present it as a patch shortly.

With respect to deferred errors, we should not just ignore
them. At the very least they should be logged.

Doug Gilbert
