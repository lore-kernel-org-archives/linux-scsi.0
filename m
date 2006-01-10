From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Tue, 10 Jan 2006 13:00:33 -0500
Message-ID: <43C3F641.8070508@emulex.com>
References: <OF5D4CA422.17C86FB6-ON412570F1.007E97FD-412570F1.007F3BE8@de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44764 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932293AbWAJSA7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jan 2006 13:00:59 -0500
In-Reply-To: <OF5D4CA422.17C86FB6-ON412570F1.007E97FD-412570F1.007F3BE8@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>



Andreas Herrmann wrote:
> I think physical_port_name was not the right choice. Sticking to
> standards the name should be permanent_port_name. So people familiar
> with FC standards have an idea what it is and all others are able to
> find an explanation in FC-GS-4.
> 
> But introducing a permanent_port_id will lead to confusion:
> Interpretation as "permanent port_id" is wrong because a port_id is
> anything but "permanent".

Agreed. In truth, even the permanent_port_name, relative to the virtual
port, is also anything but permanent.

> In conclusion James' suggestion of attributes ppn and ppn_id has some
> advantage.
> 
> And now comes the funny part:
> Question is, do I need the port_id of the physical port at all?

In my opinion - no...

 >  In
> order to determine problems with a virtual port I might have to check
> whether the physical port is properly connected and logged in to the
> fabric. Furthermore configuration of the corresponding switch port
> should be checked. (E.g. switch might allow to set limits for the
> number of NPIV connections for the switch port.)
> I may be wrong but I think the port_id of the physical port is not
> needed for this purpose.
> 
> Thus, how about introducing just what is really needed:
> Introduce permanent_port_name attribute (and leave out port_id of the
> physical port).

Works for me.

-- james s

> 
> BTW, the permanent_port_name attribute of the virtual port suffices to
> identify the fc_host of the physical port if there is a
> representation.
> And I think an LLDD should configure this attribute only for virtual
> ports.
> 
> 
> Regards,
> 
> Andreas
> 
> 
