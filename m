From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 11:22:36 -0500
Message-ID: <47B3194C.7070809@emulex.com>
References: <875344.96222.qm@web31808.mail.mud.yahoo.com>	 <47B2F9C3.8070207@emulex.com> <1202918691.3109.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33647 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbYBMQWz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 11:22:55 -0500
In-Reply-To: <1202918691.3109.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ltuikov@yahoo.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

James Bottomley wrote:
> I don't disagree with that, but the fact is that there isn't such a
> tool.   It's also a fact that the enterprise is reasonably unhappy with
> the lack of an enclosure management infrastructure, since it's something
> they got on all the other unix systems.

I don't disagree.

> I think a minimal infrastructure in-kernel does just about everything
> the enterprise wants ... and since it's stateless, they can always use
> direct connect tools in addition.
> 
> However, I'm happy to be proven wrong ... anyone on this thread is
> welcome to come up with a userland enclosure infrastructure.  Once it
> does everything the in-kernel one does (which is really about the
> minimal possible set), I'll be glad to erase the in-kernel one.

yeah, but...  putting something new in, only to pull it later, is a bad
paradigm for adding new mgmt interfaces. Believe me, I've felt users pain in
the reverse flow : driver-specific stuff that then has to migrate to upstream
interfaces, complicated by different pull points by different distros. You can
migrate a management interface, but can you really remove/pull one out ?

Isn't it better to let the lack of an interface give motivation to create
the "right" interface, once the "right way" is determined - which is what I
thought we were discussing ?    or is this simply that there is no motivation
until something exists, that people don't like, thus they become motivated ?

-- james s
