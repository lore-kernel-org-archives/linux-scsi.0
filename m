From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc3
Date: Thu, 07 Jan 2010 10:09:28 +0000
Message-ID: <4B45B2D8.7090508@redhat.com>
References: <1262797332.2946.147.camel@mulgrave.site> <4B44CCE7.9060103@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0AGKJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jan 2010 05:09:38 -0500
In-Reply-To: <4B44CCE7.9060103@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Bo.Yang@lsi.com

On 01/06/2010 05:48 PM, Boaz Harrosh wrote:
> On 01/06/2010 07:02 PM, James Bottomley wrote:
>> This patch represents the accumulated bug fixes in a variety of drivers,
>> with concentrated bug fix updates for emulex NPIV and qla2xxx EEH.
>>
> 
> James you have missed a very serious fix to scsi_lib.
>   http://www.spinics.net/lists/linux-scsi/msg41125.html
> 

Also seems to be missing a trivial patch for megaraid_sas to fix the
permissions on the poll_mode_io pseudofile:

http://marc.info/?l=linux-scsi&m=125805037602575&w=2

It's an obvious one-liner and a similar fix was already made for the
dbg_lvl file a long time ago.

Regards,
Bryn.
