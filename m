From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Tue, 14 Jan 2003 10:33:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030114183314.GC1613@beaverton.ibm.com>
References: <20030112195901.GC1414@beaverton.ibm.com> <Pine.LNX.4.33.0301140925160.1025-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0301140925160.1025-100000@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, Douglas Gilbert <dougg@torque.net>

Patrick Mochel [mochel@osdl.org] wrote:
> 
> I have reservations about blindly adding a 'char' subsystem. However, I 
> think it would be useful, and encourage someone to do the leg work..

That was not my intention. A char subsystem would need to have leg work
similar to what others did for block. We do not want to create a char
directory in sysfs and start populating it quickly to solve point
problems.

One point I was trying to make in previous mail was that if a char tree
follows the semantics of a block tree and creates a back link from the
device we need to consider the issue of "sg" (i.e. possible multiple
registers with the char subsystem per device) along with other devices up
front. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

