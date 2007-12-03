From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: aic94xx or libsas crash on X7DB3 supermicro with enclosure and sata drives
Date: Mon, 3 Dec 2007 16:11:14 +0100
Message-ID: <200712031611.14744.kb@sysmikro.com.pl>
References: <200711301022.08001.kb@sysmikro.com.pl> <20071130213313.GA7066@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:52910 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750717AbXLCPLS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Dec 2007 10:11:18 -0500
In-Reply-To: <20071130213313.GA7066@tree.beaverton.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, Alexis Bruemmer <alexisb@us.ibm.com>

On Friday 30 November 2007 22:33, Darrick J. Wong wrote:
> On Fri, Nov 30, 2007 at 10:22:07AM +0100, Krzysztof B??aszkowski wrote:
> > Hello all,
> >
> > I noticed this according to syslog. furthermore if aic94xx is connected
> > to single sata drive only then there is no crash but device is not
> > recognized too. (mysterious: "ERROR: Unidentified device type 5").
>
> There's been a substantial amount of bugfixes (as well as SATA support)
> that went into the aic94xx/libsas code between .22 and .23; could you
> please give that a try?

thank you. I've tried 2.6.23.9 and it seems to work okay and indeed there were 
made many changes some of them by you.

>
> Also, what kind of devices are attached when the system crashes?  From
> that stack trace it looks like the software thought there was a SATA
> disk attached to an expander...?

yes, i connected aic to the expander (LSISASX28) which was loaded with 16 
drives.

Best regards,
Krzysztof
>
> --D
