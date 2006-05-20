From: Denny Page <denny@cococafe.com>
Subject: Re: scsi negotiation problem on aic79xx (39320A) in 2.6.14
Date: Sat, 20 May 2006 10:12:30 -0700
Message-ID: <446F4DFE.6010201@cococafe.com>
References: <20051114224512.GF9905@mathom.us>	 <20060323180909.GD15140@mathom.us>	 <1143139044.3415.26.camel@mulgrave.il.steeleye.com>	 <20060324122715.GG15140@mathom.us>  <446EA4B5.2030507@cococafe.com>	 <1148133061.3529.3.camel@mulgrave.il.steeleye.com> <1148134836.3529.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:39626 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S1751439AbWETRMl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 13:12:41 -0400
In-Reply-To: <1148134836.3529.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

Ok, thanks.  It will be a couple of days before I can do the test.

Denny


James Bottomley wrote:
> On Sat, 2006-05-20 at 08:51 -0500, James Bottomley wrote:
>> On Fri, 2006-05-19 at 22:10 -0700, Denny Page wrote:
>>> Setting the xfer speed in the bios does not appear to affect the
>>> result with
>>> the 2.6.16 kernel.
>> That's odd ... the code to recognise the BIOS settings went into 2.6.16.
>> What does /proc/scsi/aic79xx/<n> say?
> 
> Oh ... actually, I should have traversed the tree rather than going by
> commit date.  Apparently the BIOS code didn't make it in until post
> 2.6.16, so if you check 2.6.17-rc4, it should work.
> 
> James
> 
> 
