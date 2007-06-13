From: "Harrosh, Boaz" <bharrosh@panasas.com>
Subject: RE: scsi_cmnd accessors issues
Date: Wed, 13 Jun 2007 06:32:23 -0400
Message-ID: <E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com>
References: <466EDFAC.9020104@panasas.com> <20070613085118P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:44006 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757251AbXFMKcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 06:32:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, ed.lin@promise.com, g.liakhovetski@gmx.de

From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
Sent: Tue 6/12/2007 7:51 PM
To: Harrosh, Boaz
Cc: linux-scsi@vger.kernel.org; fujita.tomonori@lab.ntt.co.jp; ed.lin@promise.com; g.liakhovetski@gmx.de
Subject: Re: scsi_cmnd accessors issues
 
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: scsi_cmnd accessors issues
> Date: Tue, 12 Jun 2007 21:02:20 +0300
>
>> [2]
>> if I use __deprecated on request_buffer, request_bufflen, and use_sg with
>> scsi_sgtable implementation Than I get below list of files complaining:
>
>(snip)
>
>> and also these files from scsi-ml that need changing when implementation changes:
>> drivers/scsi/scsi.c
>> drivers/scsi/scsi_error.c
>> drivers/scsi/scsi_debug.c
>> 
>> (see: 0004-Convert-scsi-ml-to-use-of-new-scsi_sgtable.patch at scsi_cmnd.h)
>> 
>> Which of the files do you have pending patches for? Which do you need that I send
>> what I have for them?
>
>I don't think that SCSI-ml bidi will be got into 2.6.23. 2.6.23 will
>convert as many LLDs as possible. I don't think that we need such
>patches in scsi-misc or scsi-pending now.
>
>We need to agree on what the scsi bidi looks like first. When we add
>bidi support to scsi core, we can change scsi core (scsi.c, etc)
>together.

OK! But what about the _set_ accessors what are we doing with these? are we fixing the 
code or are we adding new _set_ accessors?

Boaz
