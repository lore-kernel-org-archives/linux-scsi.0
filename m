From: "Andrew Kinney" <andykinney@advantagecom.net>
Subject: Re: aacraid on Dell PowerEdge 1800
Date: Fri, 11 Mar 2005 10:24:42 -0800
Message-ID: <423171EA.368.2C2CE275@localhost>
References: <20050311165201.GA19314@nmt.edu>
Reply-To: andykinney@advantagecom.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from mail.advantagecom.net ([65.103.151.155]:10458 "EHLO
	mail.advantagecom.net") by vger.kernel.org with ESMTP
	id S261263AbVCKS0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 13:26:48 -0500
In-reply-to: <20050311165201.GA19314@nmt.edu>
Content-description: Mail message body
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan <ryan@nmt.edu>
Cc: linux-scsi@vger.kernel.org

On 11 Mar 2005 at 9:52, Ryan wrote:

> Hello,
>   I've been through several of the news groups over the past few days
>   and
> haven't found an exact answer to my question.
> 
>   I'm trying to install Fedora Core 3 on a Dell PowerEdge 1800 server
>   that
> I just purchased, but the version of the aacraid driver for the SATA
> raid controller changed and I can't install.  
> 
>   Just like the newsgroups state, Fedora Core 2 installs just fine. 
>   My
> problem is that I can't afford to run software that is outdated. 
> There have been several security issues lately and FC3 seems to have
> fixes for them.
> 
> Any help is greatly appreciated.
> 
> Thank you.
> 
> -Ryan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html
> 

This is somewhat off-topic, so I'll be brief.  If you can install 
Fedora Core 2 and the only reason you want Fedora Core 3 is newer 
software, "man yum" after installing the 'yum' package (or choose a 
different updater to suit your prefs) will be your friend.  In other 
words, a newer OS isn't the only way to get newer software, 
especially on an OS that has a decent package management system (RPM 
in this instance).  FWIW.

Sincerely,
Andrew Kinney
President and
Chief Technology Officer
Advantagecom Networks, Inc.
http://www.advantagecom.net



