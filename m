From: Andi Kleen <andi@firstfloor.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sun, 9 Sep 2007 23:22:00 +0200
Message-ID: <20070909212159.GF25798@one.firstfloor.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47041 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbXIIVWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 17:22:01 -0400
Content-Disposition: inline
In-Reply-To: <46E46190.6080607@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@SteelEye.com>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> The current setup expresses the dependencies as they exist -- OPTIONAL 
> extras, and that is a problem once a year or so, when someone builds 

Disk support over SCSI/SATA is hardly an "optional extra". It's more the 99+%
case.

> their own kernel but must learn this fact anew.

When it costs 10000 people half an hour to learn and correct this it 
wasted 5000 hours of previous livetime.

Besides there is no good reason to have ever learned this imho.

-Andi

