From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Sat, 29 Jun 2002 03:37:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0206290336200.20256-100000@beppo>
References: <20020629060509.A23827@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020629060509.A23827@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Martin Peschke3 <MPESCHKE@de.ibm.com>, Pete Zaitcev <zaitcev@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jun 2002, Doug Ledford wrote:

> On Fri, Jun 28, 2002 at 07:04:28PM -0700, Matthew Jacob wrote:
> > 
> > FWIW, Bob Snively (on T10 commitee) has always claimed that the correct
> > response to QUEUE FULL is immediate command resubmission (i.e., *don't* wait
> > for a command to complete (the QFULL may have resulted from commands being
> > processed for *another* initiator), and *don't* a period of time for things to
> > 'get better').
> > 
> > I'm not sure  agree with this 100%, but he might have a point.
> 
> No, absolutely not!  Faster drivers are capable of restarting commands on 
> the bus so fast that in this scenario they can flood the bus with 
> selection, command, queue full sequences and not allow *any* commands to 
> complete because the bus is always tied up (this was, in fact, one of the 
> reasons that I had to put the queue handling code in the aic7xxx driver 
> when I did).

Yeah- I thought of that. But that problem actually goes away somewhat with FC
(&& QAS maybe).

