From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 6/10] lpfc 8.2.4 : Add additional sysfs and module	parameters
Date: Mon, 14 Jan 2008 09:07:25 -0500
Message-ID: <478B6C9D.5090601@emulex.com>
References: <1200034389.27954.25.camel@localhost.localdomain> <1200073991.3286.43.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48688 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYANOH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 09:07:29 -0500
In-Reply-To: <1200073991.3286.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

They are - for display purposes. We have yet to make them settable via
the transport.  I'll look into it, as it does make sense.

-- james s

James Bottomley wrote:
> On Fri, 2008-01-11 at 01:53 -0500, James Smart wrote:
>> Made link speed and link topology modifiable via sysfs
>> Make scatter gather Segment Count into a module parameter.
>>
>> Signed-off-by: James Smart <James.Smart@emulex.com>
> 
> OK ... I put this in, but shouldn't at least the link speed and possibly
> topology modifications rightly be properties of the transport class?
> 
> James
> 
> 
> 
