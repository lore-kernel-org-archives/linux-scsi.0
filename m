From: Doug Ledford <dledford@redhat.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 19:00:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729190048.V20905@redhat.com>
References: <3D453CE8.5A15FCD6@splentec.com> <3D457FF3.C7A02C57@torque.net> <20020729155518.B20905@redhat.com> <20020729145326.A23512@beaverton.ibm.com> <20020729175827.N20905@redhat.com> <20020729151027.A2657@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020729151027.A2657@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Jul 29, 2002 at 03:10:27PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2002 at 03:10:27PM -0700, Patrick Mansfield wrote:
> Doug -
> 
> I'm also doing some scsi changes - scsi_scan.c cleanup, and
> multi-path IO support.

I saw the posts you made on this.  I was just getting ready to look 
at/integrate your scsi_scan.c changes then add on the additional stuff I 
had in mind.  I thought I saw you say you were forward porting the changes 
to 2.5.28 so it will apply cleanly.  Once I saw that patch come out I was 
going to grab it.

> Do you have a tree or such that we can sync up with?

Not anything available yet (it's too broken right now).

> Any moderate changes to scsi will likely affect the multi-path changes.

Yep, that I can see for sure...

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
