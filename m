From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Tue, 14 Jan 2003 09:26:48 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0301140925160.1025-100000@localhost.localdomain>
References: <20030112195901.GC1414@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030112195901.GC1414@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, Douglas Gilbert <dougg@torque.net>


> > So from that analogy, I take it, that /char should contain st[0-N], osst[0-M]
> > and sg[0-L], with the mode and {non}rewind variants for tapes as appropriate,
> > agreed?
> > 
> > Each directory should then have the old files kdev, name, power and type that
> > existed before? Plus whatever extra files Kai, Doug and I feel the user might
> > be interested in and that in 2.4 one might find in /proc somewehere?
> 
> Yes, I would believe that /char would be modeled after block and
> contained that special nodes that tape devices need as you describe.

I have reservations about blindly adding a 'char' subsystem. However, I 
think it would be useful, and encourage someone to do the leg work..

	-pat

