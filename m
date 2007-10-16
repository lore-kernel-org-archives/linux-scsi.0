From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Date: Tue, 16 Oct 2007 11:28:59 +0100
Message-ID: <20071016112859.1b0fba0e@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710161659.28826.nickpiggin@yahoo.com.au>
	<m1lka3ishi.fsf@ebiederm.dsl.xmission.com>
	<200710160138.57893.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56997 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760077AbXJPK0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 06:26:20 -0400
In-Reply-To: <200710160138.57893.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

> I'm sure somebody will eventually write an OLS paper or something on the 
> advisability of making swapping decisions with 4k granularity when disks 
> really want bigger I/O transactions. 

Funnily enough someone thought of that many years ago. They even added
and documented it, then they made it adjustable.

See the vm section of Documentation/filesystems/proc.txt

Alan
