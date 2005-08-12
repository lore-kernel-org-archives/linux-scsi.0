From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA status report updated
Date: Fri, 12 Aug 2005 01:45:00 -0400
Message-ID: <42FC375C.3040304@pobox.com>
References: <42FC2EF8.7030404@pobox.com> <20050812074012.60487882.robn@berrymount.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:23466 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751100AbVHLFpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 01:45:08 -0400
In-Reply-To: <20050812074012.60487882.robn@berrymount.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob van Nieuwkerk <robn@berrymount.nl>
Cc: Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Rob van Nieuwkerk wrote:
> On Fri, 12 Aug 2005 01:09:12 -0400
> Jeff Garzik <jgarzik@pobox.com> wrote:
> 
> Hi Jeff,
> 
> 
>>Things in SATA-land have been moving along recently, so I updated the 
>>software status report:
>>
>>	http://linux.yyz.us/sata/software-status.html
> 
> 
> Is any progress made on SMART support ?
> I've been reading "SMART support will be integrated very soon"
> for a very long time now .. :-)

True enough :/

It's been feature-complete for a while, but the reports from testers in 
the field have made me too nervous to push it into the upstream kernel.

I might push it upstream, but disable it by default, which would allow 
for a wider test audience.

	Jeff



