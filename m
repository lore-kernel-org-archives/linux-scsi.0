From: Swen Schillig <swen@vnet.ibm.com>
Subject: Re: [patch 7/8] zfcp: Automatically attach remote ports
Date: Wed, 11 Jun 2008 09:41:11 +0200
Message-ID: <200806110941.11769.swen@vnet.ibm.com>
References: <20080610162053.144590000@de.ibm.com> <20080610193339.GA24771@wavehammer.waldi.eu.org> <20080610193645.GA25065@wavehammer.waldi.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:48994 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbYFKHlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 03:41:01 -0400
In-Reply-To: <20080610193645.GA25065@wavehammer.waldi.eu.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bastian Blank <bastian@waldi.eu.org>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tuesday 10 June 2008 21:36, Bastian Blank wrote:
> On Tue, Jun 10, 2008 at 09:33:39PM +0200, Bastian Blank wrote:
> > On Tue, Jun 10, 2008 at 06:21:00PM +0200, Christof Schmitt wrote:
> > > Automatically attach the remote ports in zfcp when the adapter is set
> > > online.
> > What do you mean with "remote ports"?
> 
> Ah, the part with the wwpn. Are you sure that this does not break on
> z900? I'm not sure about ports, but it restricts each lun to exactly one
> guest.
> 
> Bastian
> 
With remote ports I mean  "remote storage ports", so something like a DS8000.
In a switched environment a single adapter can have access to multiple
storage ports, accessing a bunch of drives (LUNs).

A port itself is not restricting anything and remote ports are not limited 
to be used by only one adapter, that's the whole purpose of those setups.

This feature has nothing to do with LUNs but only with ports, 
so I don't really get what you wanted to say with your LUN restriction.

Swen
