From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Fri, 29 Apr 2016 17:36:22 -0700
Message-ID: <5723FE06.70501@sandisk.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
 <5722320E.5080202@sandisk.com>
 <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com>
 <57223D36.60304@sandisk.com>
 <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com>
 <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0091.outbound.protection.outlook.com ([157.56.110.91]:20480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750800AbcD3Ag1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 20:36:27 -0400
In-Reply-To: <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On 04/29/2016 02:47 PM, Laurence Oberman wrote:
> Recovery with 21 LUNS is 300s that have in-flights to abort.
> [ ... ]
> eh_deadline is set to 10 on the 2 qlogic ports, eh_timeout is set
 > to 10 for all devices. In multipath fast_io_fail_tmo=5
>
> I jam one of the target array ports and discard the commands
 > effectively black-holing the commands and leave it that way until
 > we recover and I watch the I/O. The recovery takes around 300s even
 > with all the tuning and this effectively lands up in Oracle cluster
 > evictions.

Hello Laurence,

This discussion started as a discussion about the time needed to fail 
over from one path to another. How long did it take in your test before 
I/O failed over from the jammed port to another port?

Thanks,

Bart.
