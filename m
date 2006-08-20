From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 19:01:21 -0400
Message-ID: <44E8E9C1.60003@cs.wisc.edu>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu> <44E8605B.1070102@emulex.com> <44E8E398.8070904@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:14750 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932113AbWHUAB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 20:01:29 -0400
In-Reply-To: <44E8E398.8070904@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> It is not vendor specific but it is driver specific and so we need a way
> to route the message to the proper userspace handler for similar reasons
> you may need a vendor id? For example qlogic handling may be slightly
> different in userspace then broadcom. So what I am saying is I thought
> the driver and vendor ids are similar, but vendor id may not work for
> iscsi_tcp/iser?

For now let's forget this issue. I have been using the sysfs lookup
scheme because I thought people would frown on not using sysfs since it
was there. If we are allowed to add a vendor or driver id to the event
then fc can call it what it wants and base it on the pci naming and
iscsi can handle its special cases how it needs to. No reason to force
our quirks on you guys :)

