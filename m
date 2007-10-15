From: Jeff Garzik <jeff@garzik.org>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 13:44:37 -0400
Message-ID: <4713A705.60403@garzik.org>
References: <200710112011.22000.rob@landley.net>	<200710141845.44750.rob@landley.net>	<20071015014503.GF9715@thunk.org>	<200710150304.00901.rob@landley.net>	<20071015132106.GE21216@thunk.org> <20071015142945.2cb27911@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932793AbXJORpT@vger.kernel.org>
In-Reply-To: <20071015142945.2cb27911@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
>> You can pull a Model and Serial number via hdparm -i, but it's not as
>> easy to manipulate as a fixed-length MAC address.  That's why people
>> tend to use filesystem UUID's.   
> 
> ATA8 at the moment looks set to add a true "MAC" or "WWN" type identifier
> to each device.. Right now model/serial is not always unique.

WWN was added in ATA-7, AFAICS.

However, I've seen quite a few ATA-7 devices that do not bother to fill 
it in.  I wonder if ATA-8 device firmwares will act with similar 
slackness.  :)

	Jeff
