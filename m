From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 12:44:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F562FC.50806@pobox.com>
References: <200407141216.i6ECGHxg008332@harpo.it.uu.se> <40F556CE.9000707@pobox.com> <20040714164253.GE7308@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:40619 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267454AbUGNQo7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 12:44:59 -0400
In-Reply-To: <20040714164253.GE7308@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Mikael Pettersson <mikpe@csd.uu.se>, akpm@osdl.org, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Jul 14, 2004 at 11:52:46AM -0400, Jeff Garzik wrote:
> 
>>...
>>If gcc is insisting that prototypes for inlines no longer work, we have 
>>a lot of code churn on our hands ;-(  Grumble.
> 
> 
> I've counted at about 30 files with such problems in a full i386 
> 2.6.7-mm7 compile.
> 
> I've already sent patches for some of them (e.g. the dmascc.c one), and 
> they are usually pretty straightforward.

This is not a problem with the kernel.

All these files have been functioning just fine for years, with properly 
prototyped static inline functions.

Though there is a the claim that '#define inline always_inline' is 
leading to all this breakage.

	Jeff



