From: mda2376 <mda2376@gmail.com>
Subject: Re: SATA support in aic94xx
Date: Mon, 3 Apr 2006 17:11:45 -0400
Message-ID: <eb7c0afb0604031411h1e09887eu743b747c0551de6d@mail.gmail.com>
References: <89FD792A883D4B47AD469FEA2E5D1F9B17F916@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.194]:3941 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751793AbWDCVLq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Apr 2006 17:11:46 -0400
Received: by xproxy.gmail.com with SMTP id t10so873188wxc
        for <linux-scsi@vger.kernel.org>; Mon, 03 Apr 2006 14:11:45 -0700 (PDT)
In-Reply-To: <89FD792A883D4B47AD469FEA2E5D1F9B17F916@aime2k302.adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Rob,

I found a reference to the adp94xx driver on Adaptec's site as
adp94xx-openbuild-b5484.i386.tar.gz (
http://www.adaptec.com/worldwide/support/driverdetail.jsp?sess=no&filekey=adp94xx-openbuild-b5484.i386.tar.gz&language=English+US
). I was able to follow the instructions to merge the adp94xx driver
source with a 2.6.16.1 kernel however it fails to compile. I will try
again later this evening with a 2.6.13 kernel since I've read of some
people having success with this.

Is there another source from Adaptec for the adp94xx? Or is there
anyone I can contact for support on this issue?

Thanks.

On 4/2/06, Tarte, Robert <Robert_Tarte@adaptec.com> wrote:
> > Subject: SATA support in aic94xx
> >
> > I have an Adaptec AIC-9410W SAS/SATA Host Adapter integrated on a new
> > server motherboard with 4 SATA disc's attached. I'm trying to use the
> > aic94xx driver and haven't had any success with it recognizing the
> > drives. All 4 drives are detected in the Adaptec BIOS. I've tried both
> > the 2.6.13-sas kernel available from Adaptec's website and the support
> > available in 2.6.16-mm2. The controller is recognized by the kernel
> > but does not detect any of the SATA discs.
> >
> > I see that this driver is still under development but I am curious if
> > support for SATA discs is available, or if there is anything else I
> > can try? My dmesg output with aic94xx compiled in debug mode is
> > attached if this would be helpful.
>
> The aic94xx driver does not currently support SATA, but the adp94xx
> driver does.  The adp94xx driver is a transitional AIC-9410W driver for
> 2.6 and the only driver available for the 2.4 kernel.  I'll try to
> figure out where it is on the Adaptec web site ...
>
> Rob
>


--
matt.

http://www.pc.ibm.com/us/thinkpad/community/legends/index.html
