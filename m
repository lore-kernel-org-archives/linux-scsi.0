From: "Matthew Jacob" <lydianconcepts@gmail.com>
Subject: Re: generating a Linux WWN?
Date: Wed, 3 Oct 2007 11:02:58 -0700
Message-ID: <7579f7fb0710031102q34f9d02dp1c1077758dbe7982@mail.gmail.com>
References: <50432.44268.qm@web31802.mail.mud.yahoo.com>
	 <47032C67.8080109@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:50225 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbXJCSDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 14:03:06 -0400
Received: by wx-out-0506.google.com with SMTP id h31so4056411wxd
        for <linux-scsi@vger.kernel.org>; Wed, 03 Oct 2007 11:03:05 -0700 (PDT)
In-Reply-To: <47032C67.8080109@garzik.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: ltuikov@yahoo.com, Michael Reed <mdr@sgi.com>, James.Smart@emulex.com, linux-scsi <linux-scsi@vger.kernel.org>

>
> The generation algorithm is whatever makes people happy.  I would
> probably pick a fixed prefix like 0x6C 0x69 0x63 ("lin"), something that
> doesn't conflict with IEEE org ids for a long time to come.  Then,
> get_random_bytes() or hash some useful machine characteristics for the
> rest of the bytes.

The "probably" here is kind of amusing.

Look, Linux development has the moolah (look at all the money IBM and
SGI and others have shoveled in)- why don't you get a Linux block of
OUIs from the IEEE and set up an RSS-like feed so the Open Source
community can get WWNs with that OUI and a incrementing serial number
as needed- that would be a *real* service. I've thought about doing
this, but I'd have to fork over at least 1700$USD to get an official
IEEE OUI and over the last ten years I've already spent far too much
of my own money on open source support.

Heck, maybe even the IEEE would comp you on OUIs.
