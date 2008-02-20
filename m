From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Tue, 19 Feb 2008 21:28:48 -0600
Message-ID: <1203478129.3103.44.camel@localhost.localdomain>
References: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org>
	 <1203475151.3103.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802200400001.6490@bizon.gios.gov.pl>
	 <20080220031731.GA31633@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40974 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYBTD2z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 22:28:55 -0500
In-Reply-To: <20080220031731.GA31633@outback.rfc2324.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maximilian Wilhelm <max@rfc2324.org>
Cc: Krzysztof Oledzki <olel@ans.pl>, akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, mm-commits@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com

On Wed, 2008-02-20 at 04:17 +0100, Maximilian Wilhelm wrote:
> Am Wednesday, den 20 February hub Krzysztof Oledzki folgendes in die Tasten:
> > >What's the topology this thing is connected to?
> 
> > It is a Dell-1950III server with two 400GB SAS disks (RAID1) installed in 
> > a dwo disk SAS backplane.
> 
> Here it's a Dell 1950 with two 73G SAS disks (RAID1) but having four
> SAS disk slots.
> 
> If you need further information about the hardware, just let me know.

Is that directly connected or via an internal expander?

James


