From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Sun, 12 Jan 2003 11:59:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030112195901.GC1414@beaverton.ibm.com>
References: <20030109222107.GA5041@beaverton.ibm.com> <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local> <20030111154802.GS1378@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030111154802.GS1378@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, Douglas Gilbert <dougg@torque.net>, mochel@osdl.org

Willem Riede [wrlk@riede.org] wrote:
> > Looks OK to me (at least the st part). I have been planning to export some
> > settings in the directories this patch removes but it has to wait until
> > corresponding entries can be created into the (currently non-existent)
> > char tree.
> > 
> > While looking at the sysfs/bus/scsi tree after this patch, I noticed that
> > all devices currently get linked to the sd driver:
> > 

This is a bug see previous response to Kai / this thread.

> So from that analogy, I take it, that /char should contain st[0-N], osst[0-M]
> and sg[0-L], with the mode and {non}rewind variants for tapes as appropriate,
> agreed?
> 
> Each directory should then have the old files kdev, name, power and type that
> existed before? Plus whatever extra files Kai, Doug and I feel the user might
> be interested in and that in 2.4 one might find in /proc somewehere?

Yes, I would believe that /char would be modeled after block and
contained that special nodes that tape devices need as you describe.

If /char follows the model of block by creating a back link to the char
device like (/sysfs/bus/scsi/devices/0:0:0:0/char) than there will be
a issue with sg and other char devices registering on the same device.

-andmike
--
Michael Anderson
andmike@us.ibm.com

