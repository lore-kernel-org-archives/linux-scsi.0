From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Fri, 28 Jun 2002 07:22:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020628072235.A23266@redhat.com>
References: <OFB62B3AE3.6B336F4A-ONC1256BE6.002AB5F7@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OFB62B3AE3.6B336F4A-ONC1256BE6.002AB5F7@de.ibm.com>; from MPESCHKE@de.ibm.com on Fri, Jun 28, 2002 at 10:25:41AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org

On Fri, Jun 28, 2002 at 10:25:41AM +0200, Martin Peschke3 wrote:
> Hi Doug,
> 
> you wrote
> > Yes, the answer to this problem involves a timer.  Basically what I
> > suggest (and do in my driver) is set it so that the driver waits until
> > either A) a command is completed or B) 10ms has passed before sending the
> > command back out, whichever comes first.  Since most drives have had
> > plenty of time to complete one or more commands in 10ms, we assume that
> > even if we haven't got a completion yet that the drive likely has some
> > freed up resources and so we try again.
> 
> I don't like the idea to implement those retries in each HBA driver.
> It would be the same for each HBA driver:

I agree 100%.  I should have been more clear.  Take my answer above as 
"this is what my driver does to make things work properly now".  Then, 
take my previous posts about the things I'm working on and read that to be 
"I'm working on making the mid layer do this right so your driver doesn't 
have to".

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
