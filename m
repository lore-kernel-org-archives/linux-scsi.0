From: nehal@canada.com
Subject: Re: advansys problems
Date: Tue, 01 Jul 2003 13:30:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307011330.58041.nehal@canada.com>
References: <200306301731.02662.nehal@canada.com>
 <1057086331.18956.23.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24414 "EHLO
	pd3mo3so.prod.shaw.ca") by vger.kernel.org with ESMTP
	id S263590AbTGAUQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jul 2003 16:16:15 -0400
Received: from pd2mr1so.prod.shaw.ca (pd2mr1so-ser.prod.shaw.ca [10.0.141.110])
 by l-daemon (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHD00G9O4Z20G@l-daemon> for linux-scsi@vger.kernel.org; Tue,
 01 Jul 2003 14:30:38 -0600 (MDT)
Received: from pn2ml6so.prod.shaw.ca
 (pn2ml6so-qfe0.prod.shaw.ca [10.0.121.150]) by l-daemon
 (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHD007HJ4Z2AH@l-daemon> for linux-scsi@vger.kernel.org; Tue,
 01 Jul 2003 14:30:38 -0600 (MDT)
Received: from 192.168.0.111 (h24-82-78-36.vf.shawcable.net [24.82.78.36])
 by l-daemon (iPlanet Messaging Server 5.2 HotFix 1.16 (built May 14 2003))
 with ESMTP id <0HHD005GZ4Z1QM@l-daemon> for linux-scsi@vger.kernel.org; Tue,
 01 Jul 2003 14:30:38 -0600 (MDT)
In-reply-to: <1057086331.18956.23.camel@dhcp22.swansea.linux.org.uk>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

On Tuesday 01 July 2003 12:05, Alan Cox wrote:
> On Maw, 2003-07-01 at 01:31, nehal@canada.com wrote:
> > i get this error with 2.4.21-ac4
> >
> > advansys: advansys_reset: board 0: SCSI bus reset started...
> > advansys: advansys_reset: board 0: SCSI bus reset successful...
> > scsi: device set offline - not ready or command retry failed after bus
> > reset: host 0 channel 0 id 0 lun 0
> >
> > then it displays the 2 'advansys_reset' messages again and freezes...
> > i never used to get any of these problems or messages in
> > kernel version 2.4.21,
> >
> > is this bug known already?
>
> Can you try a kernel with ACPI disabled as a first guess (-ac and base
> are the same for the advansys driver)
>

that did it, i disabled ACPI ..... and now SCSI in 2.4.21-ac4 works fine 
now...

Nehal

