From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 13/15] qla4xxx: Added bsg support
Date: Sat, 12 Jun 2010 01:54:20 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871286CE351@AVEXMB1.qlogic.org>
References: <20100611074900.GA27827@sles11sp1b1.qlogic.org>
 <4C12D398.8020200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:5961 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab0FLIyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jun 2010 04:54:25 -0400
In-Reply-To: <4C12D398.8020200@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Friday, June 11, 2010 5:24 PM
>To: Vikas Chaudhary
>Cc: james.bottomley@suse.de; linux-scsi@vger.kernel.org; Ravi Anand
>Subject: Re: [PATCH 13/15] qla4xxx: Added bsg support
>
>On 06/11/2010 02:49 AM, Vikas Chaudhary wrote:
>> Added BSG support to enable application support to configure
>> ISP40XX/ISP82XX adapter.
>>
>> This patch is on top of: http://marc.info/?l=linux-
>scsi&m=126999297630764&w=2
>>
>
>Did James say that using vendor specific commands was ok? I did not see
>anything on the list. If he did, then instead of the patch above from
>Jay, you want to use iscsi bsg patches that I sent that handle Tomos's
>comments about not duplicating fc code. I sent the bsg lib to the list
>and then in my tree on kernel.org I ported the fc drivers (those might
>need a update for some patches James Smart recently sent). For those bsg
>patches you will want to then also add the vendor specific command back.

We will rebase qla4xxx bsg patch on top of your patch to use common bsg lib.

We pinged James.B couple of times  but he never replied back to our email.
So we are assuming he is OK with this approach and requesting for formal
inclusion of iscsi bsg support along with our driver support for it.

Let us know if you see any issues.

Thanks,
Vikas.
