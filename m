From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 02/10] scsi: fix integer as NULL pointer warnings
Date: Wed, 30 Apr 2008 15:34:48 -0700
Message-ID: <1209594888.24729.130.camel@brick>
References: <1209593020.24729.112.camel@brick>
	 <1209594551.3774.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:15892 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbYD3Wec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 18:34:32 -0400
Received: by wa-out-1112.google.com with SMTP id j37so599428waf.23
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2008 15:34:31 -0700 (PDT)
In-Reply-To: <1209594551.3774.37.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-04-30 at 17:29 -0500, James Bottomley wrote:
> On Wed, 2008-04-30 at 15:03 -0700, Harvey Harrison wrote:
> > drivers/scsi/FlashPoint.c:906:9: warning: Using plain integer as NULL pointer
> > drivers/scsi/FlashPoint.c:907:53: warning: Using plain integer as NULL pointer
> > drivers/scsi/FlashPoint.c:922:1: warning: Using plain integer as NULL pointer

> The flashpoint initialiser changes look wrong:  {0} is a conventional
> notation for zero initialise this structure.  Sparse should probably be
> taught to recognise that.

Actually, looking closer, should this be initialized at all?  Can we
just remove the initialization here and let them end up in .bss?

Harvey

