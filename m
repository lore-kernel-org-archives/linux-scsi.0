From: Doug Ledford <dledford@redhat.com>
Subject: Re: Broken SCSI code in the BK tree (was: 2.5.59-mm8)
Date: Thu, 6 Feb 2003 23:24:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206232440.F19868@redhat.com>
References: <384960000.1044396931@flay> <211570000.1044508407@[10.10.2.4]> <265170000.1044564655@[10.10.2.4]> <275930000.1044570608@[10.10.2.4]> <1044573927.2332.100.camel@mulgrave> <20030206172434.A15559@beaverton.ibm.com> <293060000.1044583265@[10.10.2.4]> <20030206182502.A16364@beaverton.ibm.com> <20030206230544.E19868@redhat.com> <20030206201939.27216fb1.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030206201939.27216fb1.akpm@digeo.com>; from akpm@digeo.com on Thu, Feb 06, 2003 at 08:19:39PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: patmans@us.ibm.com, mbligh@aracnet.com, James.Bottomley@steeleye.com, mikeand@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 06, 2003 at 08:19:39PM -0800, Andrew Morton wrote:
> Doug Ledford <dledford@redhat.com> wrote:
> >
> > I would much prefer that people simply test out Matthew's
> > driver and use it instead.
> 
> Where is it?
> 
> http://www.feral.com/isp.html seems to be 2.4.x-only.

As answered elsewhere, the 2.5 port isn't done yet.  That's why I said in 
my email "if it's ready for 2.5" because I was afraid Matthew hadn't 
gotten around to doing the 2.5 update yet.  However, if no one else can do 
it, I can make a 2.5 update of this driver happen (I don't suspect it 
would be that hard actually, not *that* much has to change).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
