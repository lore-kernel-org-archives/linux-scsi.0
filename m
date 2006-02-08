From: Douglas Gilbert <dougg@torque.net>
Subject: Re: scsi generic mem2disk patch for 2.6?
Date: Wed, 08 Feb 2006 16:14:51 +1000
Message-ID: <43E98C5B.1020308@torque.net>
References: <43E848E0.6010901@adelphia.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:57778 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1030564AbWBHGQQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2006 01:16:16 -0500
In-Reply-To: <43E848E0.6010901@adelphia.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Morrison <mliam@adelphia.net>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com, brking@us.ibm.com

Michael Morrison wrote:
> Howdy,
> 
> There is a sg patch for 2.4 which allows a pci bus address, or rather a
> virtual address, to be passed to the scsi generic driver in the
> sg_io_hdr struct.   This patch works wonders for doing fast IO between
> an HDTV capture card and a bunch of disks.
> 
> Is there such a beast for 2.6?   Does 2.6  already have this
> functionality built in somehow?
> If not, is there any reason why adding said functionality to the current
> 2.6.15 sg driver would not be doable?
> 
>  
> see: http://sg.torque.net/sg/mem2disk.html

Good to read that this lk 2.4 patch was useful.

Now before thinking about such a patch in the sg driver
in lk 2.6 it might be prudent to ask the various veto
holders to look at the above link and comment on whether
such an optimization is:
  - possible in the lk 2.6 series
  - if so, an external patch (such as given on the above
    link) might be developed
  - or perhaps such a facility could be put into the
    standard sg driver in lk 2.6
  - alternatively, could this be done as efficiently with
    the block layer SG_IO ioctl


Doug Gilbert
