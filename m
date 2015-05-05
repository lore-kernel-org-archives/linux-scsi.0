From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Tue, 5 May 2015 09:18:54 -0400
Message-ID: <20150505131854.GJ1971@htj.duckdns.org>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
 <1430667220-23477-2-git-send-email-stripathi@apm.com>
 <20150504154726.GA1971@htj.duckdns.org>
 <CAOHikRCZimsE+_-6dqTiCT6qRTFLp9VGt6=WHWA_Z86GBn+WRg@mail.gmail.com>
 <20150504182618.GG1971@htj.duckdns.org>
 <CAOHikRBeM3MYohDgYgbLL1uhZp+Ch4hS+eduDVbx759321=EHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34866 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbEENS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2015 09:18:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOHikRBeM3MYohDgYgbLL1uhZp+Ch4hS+eduDVbx759321=EHg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

On Tue, May 05, 2015 at 11:25:14AM +0530, Suman Tripathi wrote:
> Yeah it's very simple. The clearing of irq_stat needs to move up.
> That's it. tried and it worked. Thanks a lot !!
> Just a quick question : Why edge trigger handling is not yet present
> in libahci yet? I mean no one has used it yet ??

Yeah, no other ahci controller uses edge triggered latches.  I think
ahci spec says irq is supposed to be level triggered.

Thanks.

-- 
tejun
