From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Wed, 15 Jan 2003 00:08:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114230831.GA21324@win.tue.nl>
References: <20030112195901.GC1414@beaverton.ibm.com> <Pine.LNX.4.33.0301140925160.1025-100000@localhost.localdomain> <20030114183314.GC1613@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030114183314.GC1613@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Patrick Mochel <mochel@osdl.org>, Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Matt_Domsch@dell.com, Douglas Gilbert <dougg@torque.net>

On Tue, Jan 14, 2003 at 10:33:14AM -0800, Mike Anderson wrote:
> Patrick Mochel [mochel@osdl.org] wrote:

> > I have reservations about blindly adding a 'char' subsystem. However, I 
> > think it would be useful, and encourage someone to do the leg work..

> One point I was trying to make in previous mail was that if a char tree
> follows the semantics of a block tree and creates a back link from the
> device we need to consider the issue of "sg" (i.e. possible multiple
> registers with the char subsystem per device) along with other devices up
> front. 

One question is: do char devices exist?
A possible point of view is that there is the wide class of devices,
and that there are several subclasses. (Like: block devices, network devices,
USB devices.)

Andries
