From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: Mon, 29 Jul 2002 09:00:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0207290859540.23252-100000@dragon.pdx.osdl.net>
References: <1027955906.842.38.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1027955906.842.38.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On 29 Jul 2002, Alan Cox wrote:

| On Sat, 2002-07-27 at 23:07, Matthew Dharm wrote:
| > >  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
| > > -		      512, SD_TIMEOUT, MAX_RETRIES);
| > > +		      255, SD_TIMEOUT, MAX_RETRIES);
|
| Adjust it and the buffer size to be even and I'll test run it in -ac

One of the earlier emails quoted a 252 max. size from a newer spec.

-- 
~Randy

