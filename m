From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Patch] SCSI: Retrieve Cache Mode Using SG_ATA_16 if normal routine
 fails
Date: Tue, 11 Oct 2011 09:42:26 -0400
Message-ID: <4E9447C2.20707@garzik.org>
References: <CADDb1s2=Ykh711grVjHV542pVJwpf1K+zzTRVEY2KH3T=wB_xg@mail.gmail.com> <4E941D5E.6060101@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E941D5E.6060101@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NamJae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 10/11/2011 06:41 AM, Hannes Reinecke wrote:
> ATA_16 is a rather recent command, and most older drives simply can't
> cope with this. Instead they just kick the error handler and go offline
> eventually.

I tend to agree...  there are a great many USB drives out there, and 
this has not really been tested with a large test selection, has it?

	Jeff
