From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Wed, 25 Jan 2006 23:10:41 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601252306270.5794@kai.makisara.local>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
 <Pine.LNX.4.64.0601241251460.23364@localhost.localdomain>
 <20060124202306.GA8422@us.ibm.com> <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:31880 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932079AbWAYVIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 16:08:46 -0500
In-Reply-To: <Pine.LNX.4.64.0601241535290.23364@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chip Coldwell <coldwell@redhat.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Gerhard Schneider <gs@ilsb.tuwien.ac.at>, linux-scsi@vger.kernel.org

On Tue, 24 Jan 2006, Chip Coldwell wrote:

> On Tue, 24 Jan 2006, Patrick Mansfield wrote:
> 
> > On Tue, Jan 24, 2006 at 12:52:36PM -0500, Chip Coldwell wrote:
> >
> > > Put
> > >
> > > options st try_direct_io=0
> >
> > >
> > > in /etc/modprobe.conf.  Direct I/O defeats read-ahead, and
> > > significantly (factor of >5) degrates read performance.  I don't know
> > > about writes.
> >
> > For tape???
> 
> Yes, for tape.  We verified this with a DAT72 DDS drive.
> 
How did you do the tests? I would like to be able to reproduce this 
finding because there is something wrong somewhere. With any decent read() 
and write() byte counts (the 64 kB you mention in another message is 
decent) you should not find direct i/o slower than using the driver 
buffer. I have not seen anything like this with my DDS-4 drive (same 
speed as DAT72).

-- 
Kai
