From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Wed, 27 Oct 2004 16:34:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87f94c3704102713343d6b204f@mail.gmail.com>
References: <1098833278.4914.24.camel@zezette>
	 <20041027081713.GC32712@marowsky-bree.de>
	 <1098903759.12464.32.camel@zezette>
	 <1098905875.4472.92.camel@gator.sc.steeleye.com>
	 <1098908346.12464.44.camel@zezette>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:2375 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262701AbUJ0UeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 16:34:23 -0400
Received: by wproxy.gmail.com with SMTP id 68so368331wri
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2004 13:34:23 -0700 (PDT)
In-Reply-To: <1098908346.12464.44.camel@zezette>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> I just consider it annoying for the HSG80 / HSV* family
> controlers :
> 

<snip>

> - Either way, these controler families are *not* high-end devices,
> whatever the criteria (capacity, throughput, cache, alarming, ...). The
> whole ghost-path notion being the best evidence.
> 

HP will not agree with "not high-end devices".  The HSV line in
particular is a very good performing system and is designed to compete
with the EMC Symmetrix line.

The EVA (HSV based) is definately targeted at Data Centers with lots
of servers using it as back-end storage simultaneously.

Greg
-- 
Greg Freemyer
