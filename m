From: Doug Ledford <dledford@redhat.com>
Subject: Re: Lun 0
Date: Mon, 21 Oct 2002 12:18:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021161857.GB28914@redhat.com>
References: <B9D57B41.43FC%mheinz@infiniconsys.com> <3DB421F8.438FF804@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB421F8.438FF804@patni.com>
List-Id: linux-scsi@vger.kernel.org
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>

On Mon, Oct 21, 2002 at 09:19:12PM +0530, MShetty wrote:
> Hi,
> 
> Thanks a lot for all the replies
> 
> A piece of code I am reading, sends the Inquiry cmd to lun 0 first and then to
> the actual lun to be probed. As only SCSI devices have the concept of luns... I
> think the 1st probe to lun 0 is to check if it is a SCSI device but... on 2nd
> thought the same can be inferred by probing for lun n.

No.  SCSI devices, if present on a given target, must have something on 
LUN 0.  That item on LUN 0 doesn't have to be online, but it has to exist 
and respond to the INQUIRY command.  LUNs > 0 need not exist.

> I have read something which says that some devices may mess up if probed for
> luns > 0. Is this true ??

Yes.  Absolutely.  Lots of CD-ROM drives will hard lock when you try and 
probe for LUNs > 0.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
