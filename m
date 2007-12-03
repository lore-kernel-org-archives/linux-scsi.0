From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sun, 2 Dec 2007 19:17:32 -0600 (CST)
Message-ID: <20071203011732.2CEABDBA2@gherkin.frus.com>
References: <6A73BEE8-9D45-4B75-8756-3008A4B1FDF4@orcon.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754674AbXLCBRy@vger.kernel.org>
In-Reply-To: <6A73BEE8-9D45-4B75-8756-3008A4B1FDF4@orcon.net.nz>
 "from Michael Cree at Dec 3, 2007 09:53:53 am"
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Cree <mcree@orcon.net.nz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
List-Id: linux-scsi@vger.kernel.org

Michael Cree wrote:
> On 1/12/2007, at 11:42 AM, Andrew Morton wrote:
> > On Sat, 01 Dec 2007 11:30:01 +1300
> > Michael Cree <mcree@orcon.net.nz> wrote:
> >
> >> Bob Tracy wrote:
> >>>  Here's
> >>> hoping someone else is seeing this or can replicate it in the  
> >>> meantime.
> >>
> >> Snap.
> >>
> >> 2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is
> >> populated no partitions of the scsi sub-system are seen.  Looks  
> >> like ide sub-system similarly affected.
> 
> [snip]
> 
> >> eth0: Digital DS21142/43 Tulip rev 65 at Port 0x200009400,
> >> 08:00:2b:87:4c:b0, IRQ 45.
> >> Linux video capture interface: v2.00
> >> scsi_id[402]: scsi_id: unable to access '/block'
> >
> > I guess this is where things go bad.
> 
> Yes, that is what I thought too.

Thanks for the confirmation of the error condition.  As best I can
recall, your boot log is substantially the same as what I saw.

Finally got back in town.  Starting the git-bisect process.  I've got
a relatively slow network connection, and the PWS 433au isn't exactly
what I would call "fast" by modern standards, so bear with me while I
get things set up and crank through this.  The clone of the 2.6 tree
will take several more hours to finish downloading.  I anticipate the
best pace I'll be able to manage after that is two iterations in a 24-
hour period.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
