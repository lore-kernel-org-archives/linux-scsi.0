From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] [REPOST] SCSI and FC Transport: add netlink support for
 posting of transport events
Date: Sun, 20 Aug 2006 09:30:06 -0400
Message-ID: <44E863DE.7040802@emulex.com>
References: <1155936609.12933.5.camel@localhost.localdomain> <44E68F65.2000701@cs.wisc.edu> <44E6FC57.5050502@emulex.com> <44E7C86E.1030302@cs.wisc.edu> <44E8605B.1070102@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:23215 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750765AbWHTNpU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Aug 2006 09:45:20 -0400
In-Reply-To: <44E8605B.1070102@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

After thinking about this a little more - most vendor apps will have
already perused sysfs to find the adapters they care about. If so, they
already have the host no to vendor mapping. So why pass the vendor id ?

It's for the scenario in which someone is logging event messages for
later, and may not have the sysfs tree present.  Hmmm... implies the
logging app, to be really useful, should also log the syfs to host_no
relation as part of it's start up.

It's a good question/discussion, but it hasn't changed my position:
- for generic/well-known transport events, no vendor id is needed
- for vendor-specific events, supply vendor id.

-- james s
