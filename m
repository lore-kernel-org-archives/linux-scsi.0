From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 2/3] ata: Add APM X-Gene SoC AHCI SATA host
 controller driver
Date: Fri, 21 Feb 2014 14:00:58 -0500
Message-ID: <20140221190058.GB12830@htj.dyndns.org>
References: <1393004853-25994-1-git-send-email-lho@apm.com>
 <1393004853-25994-2-git-send-email-lho@apm.com>
 <1393004853-25994-3-git-send-email-lho@apm.com>
 <20140221175542.GA12830@htj.dyndns.org>
 <CAPw-ZTkWbYfCKs+4ZJ7_zuuFZy5RH51319Pj=3i5kdg162UVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:58836 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaBUTBC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 14:01:02 -0500
Content-Disposition: inline
In-Reply-To: <CAPw-ZTkWbYfCKs+4ZJ7_zuuFZy5RH51319Pj=3i5kdg162UVXg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hello, Loc.

On Fri, Feb 21, 2014 at 10:43:52AM -0800, Loc Ho wrote:
> Do you want this for all functions or only one that with comment? Also,
> for both drivers - host and PHY drivres?

Oh, no need to do that for every function.  It's just customary to use
function comment when there's sufficient amount to explain for the
whole function.

> > Can you please go back two reviews and re-read what I requested?
> > Also, if you're unsure, please don't hesitate to ask back.  It's
> > usually a lot easier for both parties than iterating through patchsets
> > without properly understanding each other.
> >
> 
> Before posting this morning, I had gone over all response email from you
> since we first interacted. I am not quite follow what you want here. Are
> you suggesting that I should move this out as an errata patch?

Hmmm... maybe I was too ambiguous.  Because the behavior is quite
unusual and can make the error handling behavior deviate, I think it
deserves to explain 1. why such behavior is necessary and 2. what the
implications are (e.g. in corner cases, how long it could add to reset
timeout) and preferably 3. rationale for choosing this specific
approach given #1 and #2, so that when someone else reads the code
later on [s]he doesn't have to second-guess the original intention of
the workaround.

Thanks.

-- 
tejun
