From: Doug Ledford <dledford@redhat.com>
Subject: Re: SCSI reserve/release
Date: Thu, 27 Feb 2003 18:21:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5E9D75.7040309@redhat.com>
References: <20030227205135.31139.qmail@web14612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030227205135.31139.qmail@web14612.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Linda Lee <lindaclee2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Linda Lee wrote:
> I'd like to simulate the SCSI-3 Persistent Group
> Reservation of Solaris on Linux using Linux
> reserve/release mechanism.  My understanding is that
> to make reservation on the device on Linux, I can
> issue ioctl() with SCSI_IOCTL_SEND_COMMAND along with
> SCSI command "RESERVE" as part of the input data. It
> is similar for the release mechanism.  Instead of
> "RESERVE" command in the ioctl, put "RELEASE" instead.
> 
> Regarding the SCSI reset, I can issue ioctl() with
> SG_SCSI_RESET.
> 
> Is my approach correct?  Does anyone had done this
> before?

I built a small library and a small application that does this on linux. 
  I then handed it off to the HA people in Red Hat.  Don't know where it 
could be found now, but it used to be available as an RPM named 
scsires-0.7-2.i386.rpm and was distributed in the older Red Hat Linux 
7.2 HA solution.  My guess is that a google search on that file name 
will provide a hit somewhere.


-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606


