From: MShetty <mranalini.shetty@patni.com>
Subject: Re: Lun 0
Date: Mon, 21 Oct 2002 21:19:12 +0530
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DB421F8.438FF804@patni.com>
References: <B9D57B41.43FC%mheinz@infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Thanks a lot for all the replies

A piece of code I am reading, sends the Inquiry cmd to lun 0 first and then to
the actual lun to be probed. As only SCSI devices have the concept of luns... I
think the 1st probe to lun 0 is to check if it is a SCSI device but... on 2nd
thought the same can be inferred by probing for lun n.

I have read something which says that some devices may mess up if probed for
luns > 0. Is this true ??


Thanks and Regards,
M Shetty


