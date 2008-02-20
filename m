From: Maximilian Wilhelm <max@rfc2324.org>
Subject: Re: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Wed, 20 Feb 2008 19:14:10 +0100
Message-ID: <20080220181410.GB31633@outback.rfc2324.org>
References: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org> <1203475151.3103.40.camel@localhost.localdomain> <Pine.LNX.4.64.0802200400001.6490@bizon.gios.gov.pl> <20080220031731.GA31633@outback.rfc2324.org> <1203478129.3103.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rfc2324.org ([89.149.194.216]:43420 "EHLO rfc2324.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbYBTSOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 13:14:37 -0500
Content-Disposition: inline
In-Reply-To: <1203478129.3103.44.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Maximilian Wilhelm <max@rfc2324.org>, Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, mm-commits@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com

Am Tuesday, den 19 February hub James Bottomley folgendes in die Tasten:

> On Wed, 2008-02-20 at 04:17 +0100, Maximilian Wilhelm wrote:
> > Am Wednesday, den 20 February hub Krzysztof Oledzki folgendes in die Tasten:
> > > >What's the topology this thing is connected to?

> > > It is a Dell-1950III server with two 400GB SAS disks (RAID1) installed in 
> > > a dwo disk SAS backplane.

> > Here it's a Dell 1950 with two 73G SAS disks (RAID1) but having four
> > SAS disk slots.

> > If you need further information about the hardware, just let me know.

> Is that directly connected or via an internal expander?

The disks are connected to an expander.
Have a look at http://files.rfc2324.org/mptsas_panic/DSC_2133.jpg for
a picture.

Further questions?

Ciao
Max
-- 
	Follow the white penguin.
