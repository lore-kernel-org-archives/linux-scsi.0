From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Asynchronous scsi scanning
Date: Thu, 11 May 2006 14:09:56 -0500
Message-ID: <44638C04.8010507@cs.wisc.edu>
References: <20060511143352.GI12272@parisc-linux.org> <44637F4C.3070102@cs.wisc.edu> <20060511182119.GK12272@parisc-linux.org> <44638736.70708@cs.wisc.edu> <20060511185602.GL12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:18305 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750715AbWEKTGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 15:06:36 -0400
In-Reply-To: <20060511185602.GL12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, May 11, 2006 at 01:49:26PM -0500, Mike Christie wrote:
>>> 2) Unless it's serialised (in which case it still takes two hours to
>>> boot), you lose drive numbering.
>> Drive numbering refers to the bus, target numbering right?
> 
> No, I mean sda, sdb, sdc, etc.
> 

Ah ok, I see what you mean.
