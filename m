From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 14:29:45 +0100
Message-ID: <20071015142945.2cb27911@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015014503.GF9715@thunk.org>
	<200710150304.00901.rob@landley.net>
	<20071015132106.GE21216@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764992AbXJON0q@vger.kernel.org>
In-Reply-To: <20071015132106.GE21216@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

> You can pull a Model and Serial number via hdparm -i, but it's not as
> easy to manipulate as a fixed-length MAC address.  That's why people
> tend to use filesystem UUID's.   

ATA8 at the moment looks set to add a true "MAC" or "WWN" type identifier
to each device.. Right now model/serial is not always unique.
