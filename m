From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [linux-usb-devel] Re: inquiry in scsi_scan.c
Date: Mon, 06 Jan 2003 15:03:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301062103.h06L3T504203@localhost.localdomain>
References: <luben@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA22176
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jan 2003 13:03:39 -0800
In-Reply-To: Message from Luben Tuikov <luben@splentec.com>
   of "Mon, 06 Jan 2003 15:49:08 EST." <3E19EBC4.6000601@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Andries.Brouwer@cwi.nl, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

luben@splentec.com said:
> 	bytes_got = max(bytes_requested - cmd->resid, 0); 
[...]
> 	/* let's rely on the transport to have correctly set */
> 	/* cmd->resid and report a broken device server */
> 	</insert code here/> 

I'm afraid that for a large number of HBAs in the tree SCpnt->resid just isn't 
reliable (nothing ever needed it, and it's overhead to compute, so they didn't 
bother).

James


