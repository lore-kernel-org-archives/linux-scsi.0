From: Lincoln Dale <ltd@cisco.com>
Subject: Re: Transport Attributes -- attempt#3
Date: Sat, 17 Jan 2004 11:23:59 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20040117112151.0495e2e0@171.71.163.14>
References: <20040114181241.GK27591@localhost>
 <20040107185420.GA30627@localhost>
 <20040108131717.A9700@infradead.org>
 <20040114181241.GK27591@localhost> <20040114233457.GA23840@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:10939 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S265849AbUAQAYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 19:24:08 -0500
In-Reply-To: <20040114233457.GA23840@praka.local.home>
References: <20040114181241.GK27591@localhost>
 <20040107185420.GA30627@localhost>
 <20040108131717.A9700@infradead.org>
 <20040114181241.GK27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org

Hi Andrew,

At 10:34 AM 15/01/2004, Andrew Vasquez wrote:
> > +/* the FiberChannel Tranport Attributes: */
> > +fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
> > +fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
> > +fc_transport_rd_attr(port_id, "0x%x\n");
>
>Purely aesthetics : PortIDs are typically viewed as three hex bytes
>padded with zeros, i.e. 010203.  Perhaps this may be more appropriate:
>
>         fc_transport_rd_attr(port_id, "0x%06x\n");

yes, i'd like to see that too.

but note that most FC switches out there don't support the full range of 
239 Domain_IDs (first octet of FC_ID), so for 'most' people, it'd work out 
correctly anyway (domain_id between 97 and 127).


cheers,

lincoln.

