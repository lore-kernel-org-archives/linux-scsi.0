From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5.31 scsi_error.c cleanup
Date: Thu, 22 Aug 2002 10:05:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208221405.g7ME5XE02754@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA26329
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2002 07:05:36 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Mon, 12 Aug 2002 16:38:16 PDT." <20020812233815.GA1334@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> I did not change any of the current error policy. I would like to do
> that in the future. 

Looking through the patch, it seems you've changed the offline behaviour.  Now 
if all error recovery fails, the machine will panic instead of just offlining 
the failed device.  I know offlining has never worked correctly, because it 
always seems to leave the system hanging, but it is a useful feature for large 
machines with many SCSI attachements, could you look at trying to get it to 
work corectly?

Thanks,

James


