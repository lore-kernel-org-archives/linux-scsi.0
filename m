From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: /sys/.../enclosure_device:<something> ?
Date: Wed, 13 Jan 2016 11:15:05 -0800
Message-ID: <1452712505.2363.19.camel@HansenPartnership.com>
References: <2054826122.7150196.1452702532315.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44536 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932757AbcAMTPL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 14:15:11 -0500
In-Reply-To: <2054826122.7150196.1452702532315.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anne Mulhern <amulhern@redhat.com>, linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 11:28 -0500, Anne Mulhern wrote:
> Hi!
> 
> I'm looking for the most precise information available about the
> meaning of <something>
> and from what it is derived. I'm also interested in what the values
> in the files in that directory
> may mean. Could somebody point me there?

It's in drivers/misc/enclosure.c:enclosure_link_name()

> Also, how can there be more than one enclosure_device subdirectory
> for the same device,
> or, alternatively, why isn't <something> stored in a file in the more
> regularly named directory
> /sys/.../enclosure_device?

I'm not sure I parse the question, but if you're asking how can a
single enclosure bay appear to have more than one device, that's when
there are multiple paths to the device.

James

> (It would be nice to be able to obtain the value of <something> using
> libudev's attribute
> lookup facilities, but making that value a part of the specially
> named directory enclosure_device:<something>
> makes such a process especially difficult.)
> 
> Thanks,
> 
> - mulhern
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

