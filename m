From: Andi Kleen <ak@suse.de>
Subject: Re: Removing BROKEN scsi drivers
Date: Thu, 6 Oct 2005 12:23:41 +0200
Message-ID: <200510061223.41800.ak@suse.de>
References: <200510051314.33411.ak@suse.de> <4344556B.3030700@torque.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:64648 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1750789AbVJFKXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 06:23:24 -0400
In-Reply-To: <4344556B.3030700@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Thursday 06 October 2005 00:36, Douglas Gilbert wrote:

>
> So whoever marked the advansys driver as broken
> was making some political statement IMO. If it
> ain't broken, it shouldn't be marked as BROKEN.

Well if it's not broken it should be marked unbroken.

If it only works on x86 as hch stated one way would
be to make it dependent on (X86 && !X86_64)

-Andi
