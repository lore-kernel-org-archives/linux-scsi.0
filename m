From: Willem Riede <wrlk@riede.org>
Subject: Re: 2.4.19 SCSI error handing, door locking, etc
Date: Sun, 13 Oct 2002 11:59:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021013155910.GC1550@linnie.riede.org>
References: <Pine.LNX.4.44.0210051043290.3098-100000@kai.makisara.local>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210051043290.3098-100000@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Sat, Oct 05, 2002 at 03:54:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On 2002.10.05 03:54 Kai Makisara wrote:
> On Fri, 4 Oct 2002, Patrick Mansfield wrote:
> 
> > Kai - should st.c (and osst.c?) be using
> scsi_ioctl(SCSI_IOCTL_DOORLOCK/UNLOCK)?
> >
> st.c should definitely do it. I will do the changes very soon (together
> with some other changes related to resets done by the midlayer). (The
> ioctl did not exist when I put the current code into st.c and I have not
> seen any pressing reason the change that until now.) The same changes
> should probably be made to osst.c. I will tell the maintainers.
> 
Kai,

If you would be so kind as to tell me how you're changing st to do this,
I'll make the equivalent change for osst.

Thanks, Willem Riede.
