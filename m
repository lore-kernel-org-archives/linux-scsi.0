From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 07/15] qla4xxx: Added support for ISP82XX
Date: Tue, 15 Jun 2010 19:58:18 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871286CE743@AVEXMB1.qlogic.org>
References: <20100611074656.GA27762@sles11sp1b1.qlogic.org>
 <4C1531FE.20103@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:23068 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0FPC6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2010 22:58:20 -0400
In-Reply-To: <4C1531FE.20103@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Sunday, June 13, 2010 12:31 PM
>To: Vikas Chaudhary
>Cc: james.bottomley@suse.de; linux-scsi@vger.kernel.org; Ravi Anand; Karen
>Higgins
>Subject: Re: [PATCH 07/15] qla4xxx: Added support for ISP82XX
>
>Patches 1-6 look good.
>
>For this one I guess remove the extra scsi_block/unblock calls as
>discussed in the other thread and then remove the (void) casts in the
>qla4xxx_cmd_wait() calls.
>
>
>On 06/11/2010 02:46 AM, Vikas Chaudhary wrote:
>> +			(void) qla4xxx_cmd_wait(ha);

I will resubmit all patches from 1-10 with updated patch 7 and 10
along with driver version change. For BSG patches we will wait for
everybody's comments.

Thanks,
Vikas.
