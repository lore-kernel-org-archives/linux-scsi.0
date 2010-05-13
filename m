From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [LSF/VM TOPIC] Generic SAN Management via Oracle VM Storage
 Connect Plugin.
Date: Thu, 13 May 2010 14:56:02 -0700
Message-ID: <20100513215602.GB13692@mail.oracle.com>
References: <20100401010539.GF28680@mail.oracle.com>
 <4BB3FC60.1050405@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:27051 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab0EMWi3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2010 18:38:29 -0400
Content-Disposition: inline
In-Reply-To: <4BB3FC60.1050405@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

On Wed, Mar 31, 2010 at 08:52:32PM -0500, Mike Christie wrote:
> >While initiated for the Oracle VM product, I've written a standalone
> >application that uses the plugin, giving a unified view of storage that
> >can be managed from one place.  The program will be open source, of
> >course.  I'm looking for input from storage folks at LFS on what
> >I can do to make this even more useful to general SAN management.
> 

[Sorry I took so long to respond. ]

> Sounds interesting. I have been trying to just get initiator tools
> and libs that work with all hbas. We have a common iscsi tool for
> iscsi initiators and was hoping fcoeadmin could be made more generic
> to work for all fcoe and fc drivers (there is work to make a the
> linux hbaapi lib work for all drivers too).
> 
> Is your interface based on anything like SMI-S, or something new? It
> will work on the initiator and targets, right? Will it work on
> switches?

	It's new.  It's designed by a few folks here at Oracle in
concert with a (surprisingly large) number of our storage partners.
It's not designed as being a generic part of iSCSI.  Rather, it
exists as a common programmatic interface to the SAN/NAS machines'
existing control software.  So it works for both iSCSI and FC when the
vendor has provided plugin support for both.
	There is no provision for switches at this time.  It's about
LUN/file management.

Joel

-- 

"Three o'clock is always too late or too early for anything you
 want to do."
        - Jean-Paul Sartre

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
