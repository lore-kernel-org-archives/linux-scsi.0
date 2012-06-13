From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
Date: Tue, 12 Jun 2012 18:11:14 -0700
Message-ID: <20120613011114.GF6765@kroah.com>
References: <1339511190-2440-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49793 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2FMBLU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jun 2012 21:11:20 -0400
Received: by pbbrp8 with SMTP id rp8so1563547pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jun 2012 18:11:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1339511190-2440-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>

On Tue, Jun 12, 2012 at 10:26:30AM -0400, Namjae Jeon wrote:
> Update information of Seagate Portable HDD and WD My Passport HDD in
> quirk list.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
>  1 file changed, 12 insertions(+)

What happened to the 2 other patches in this series?

And why is your From: email address different from your Signed-off-by:
address?  If you are emailing from a different email account than your
"real" one, please put a "From: My name <email_address>" as the first
line in the body of the text for the patch, so git will get things
correct (see the file, Documentation/SubmittingPatches for details about
this.)

So, care to resend these so I can apply them?

thanks,

greg k-h
