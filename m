From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2 PATCHES: fix request_tranferlength
Date: 29 Jul 2002 16:18:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1027955906.842.38.camel@irongate.swansea.linux.org.uk>
References: <20020721151523.D1909@one-eyed-alien.net>
	<20020727150706.A3121@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020727150706.A3121@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Sat, 2002-07-27 at 23:07, Matthew Dharm wrote:
> >  	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
> > -		      512, SD_TIMEOUT, MAX_RETRIES);
> > +		      255, SD_TIMEOUT, MAX_RETRIES);

Adjust it and the buffer size to be even and I'll test run it in -ac

