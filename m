From: Henk Jan Priester <hj@justcroft.com>
Subject: Que: generic scsi driver (sg) SG_IO ioctl
Date: Thu, 16 Oct 2003 11:18:55 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310161109430.26363-100000@mars.justcroft.intern>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siemens4.servercity.co.uk ([217.205.138.46]:30216 "EHLO
	justcroft.co.uk") by vger.kernel.org with ESMTP id S262781AbTJPJTF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2003 05:19:05 -0400
Received: from mars [62.59.36.110]
	by justcroft.co.uk [212.47.84.192]
	with SMTP (MDaemon.Standard.v4.0.2.R)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2003 10:13:09 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello,

I am currently writing a program to communicate with 
Xerox Xpress Plotter using the generic SCSI driver (kernel 2.4.20).

I am using the ioctl SGIO to send the SCSI pakkets to the
plotter, everything works fine till I start sending the plot data.
(model enquiry is ok, roll selection is ok, print setup is ok)
The ioctl goes ok but the status = 8, masked_status = 4, which
is busy if I am correct.
Does anybody know what can be the problem if the in case?

Is there also a limit on the pakket size you can send with ioctl 
SG_IO command?

Regards,

Henk Jan 

-- 
H.J. Priester                           email:	hjpriester@justcroft.com
Justcroft Technical Systems B.V.        Tel:   +31 70 3644131 
Atjehstraat  21, 2585 VG	        Fax:   +31 70 3107593	
The Netherlands                        	WWW:   www.justcroft.com 
-------------------------------------------------------------------------------


