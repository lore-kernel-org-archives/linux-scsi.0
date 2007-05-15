From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Asynchronous scsi scanning
Date: Tue, 15 May 2007 16:28:34 -0700
Message-ID: <464A4222.4000208@linux.intel.com>
References: <1179073116.3723.45.camel@mulgrave.il.steeleye.com>	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>	 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>	 <1179153096.3703.23.camel@mulgrave.il.steeleye.com>	 <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>	 <17841.simon.1179228389@5ec7c279.invalid>	 <20070515120228.GI10562@parisc-linux.org>	 <4649E03A.1090004@simon.arlott.org.uk>	 <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:4968 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755883AbXEOX3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 19:29:47 -0400
In-Reply-To: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

Satyam Sharma wrote:
>> > >semantics of it (read-only?  read-write?  write-only?
> 
> Well, it _has_ to be write, don't really care if it's read-write or
> write-only. I would still prefer read-write, but we can go ahead with
> write-only too. It doesn't really matter, does it?

just to be devils advocate...
it should be a read that returns when done, and that can be polled
