From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: /sys/.../enclosure_device:<something> ?
Date: Wed, 13 Jan 2016 12:30:07 -0800
Message-ID: <1452717007.2363.22.camel@HansenPartnership.com>
References: <2054826122.7150196.1452702532315.JavaMail.zimbra@redhat.com>
	 <1452712505.2363.19.camel@HansenPartnership.com>
	 <1033193682.7255311.1452716104867.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44970 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbcAMUaJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 15:30:09 -0500
In-Reply-To: <1033193682.7255311.1452716104867.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anne Mulhern <amulhern@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 15:15 -0500, Anne Mulhern wrote:
> 
> 
> 
> ----- Original Message -----
> > From: "James Bottomley" <James.Bottomley@HansenPartnership.com>
> > To: "Anne Mulhern" <amulhern@redhat.com>, 
> > linux-scsi@vger.kernel.org
> > Sent: Wednesday, January 13, 2016 2:15:05 PM
> > Subject: Re: /sys/.../enclosure_device:<something> ?
> > 
> > On Wed, 2016-01-13 at 11:28 -0500, Anne Mulhern wrote:
> > > Hi!
> > > 
> > > I'm looking for the most precise information available about the
> > > meaning of <something>
> > > and from what it is derived. I'm also interested in what the
> > > values
> > > in the files in that directory
> > > may mean. Could somebody point me there?
> > 
> > It's in drivers/misc/enclosure.c:enclosure_link_name()
> > 
> 
> Thanks. I will do my best with that.
> 
> > > Also, how can there be more than one enclosure_device
> > > subdirectory
> > > for the same device,
> > > or, alternatively, why isn't <something> stored in a file in the
> > > more
> > > regularly named directory
> > > /sys/.../enclosure_device?
> > 
> > I'm not sure I parse the question, but if you're asking how can a
> > single enclosure bay appear to have more than one device, that's
> > when
> > there are multiple paths to the device.
> 
> I'm afraid the word path is so overloaded...I'm assuming that you
> are talking about a multipathed environment, where two device nodes, 
> say /dev/sdb, /dev/sdc correspond to the same disk, and are hence
> multipathed. Of course, in that case, it makes sense that both 
> devices should share a bay. And that's what I observe.

Yes, that's what I meant.

> If I understand you correctly, then my question is actually the 
> opposite. Why does it look as if the directories are set up so that 
> there can be multiple bays for a single device...i.e., the directory 
> naming scheme allows me to specify an arbitrary number of bays for 
> /dev/sdb. It seems like there should never be more than one?

There is only one bay per device since a physical disk can't be in more
than one bay at once.  Why do you think it was set up to allow >1?

James

> - mulhern
> 
> > James
> > 
> > > (It would be nice to be able to obtain the value of <something>
> > > using
> > > libudev's attribute
> > > lookup facilities, but making that value a part of the specially
> > > named directory enclosure_device:<something>
> > > makes such a process especially difficult.)
> > > 
> > > Thanks,
> > > 
> > > - mulhern
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux
> > > -scsi"
> > > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  
> > > http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux
> > -scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

