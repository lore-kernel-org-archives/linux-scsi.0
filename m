From: Dinakar Guniguntala <dino@in.ibm.com>
Subject: Re: What breaks aic7xxx in post 2.6.12-rc2 ?
Date: Wed, 18 May 2005 20:10:34 +0530
Message-ID: <20050518144034.GB3937@in.ibm.com>
References: <20050516085832.GA9558@gmail.com> <20050517071307.GA4794@in.ibm.com> <20050517002908.005a9ba7.akpm@osdl.org> <1116340465.4989.2.camel@mulgrave> <20050517170824.GA3931@in.ibm.com> <1116354894.4989.42.camel@mulgrave> <20050518090722.GA3937@in.ibm.com> <1116425559.5027.1.camel@mulgrave>
Reply-To: dino@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262246AbVERPEk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1116425559.5027.1.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, gregoire.favre@gmail.com, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 18, 2005 at 09:12:39AM -0500, James Bottomley wrote:
> > 
> > So are these patches getting into -mm first or -rc5 ??
> 
> Damn, I knew you were going to ask that ... the problem is it's the last
> in a long line of invasive adaptec patches that sit in my scsi-misc-2.6
> tree ... I suppose we can't have the aic driver slightly hosed for
> 2.6.12; I'll see if I can extract them.
> 

You actually thought you could get away with that ?? :)

Seriously, scsi takes a long time to boot even normally, but with this
bug, it takes forever and a few more retries before it finally boots up.

I would really appreciate if you could extract and send them upstream,
Thanks

	-Dinakar
