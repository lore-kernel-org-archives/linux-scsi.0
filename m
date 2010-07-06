From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
Date: Mon, 5 Jul 2010 22:20:42 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128B12304@AVEXMB1.qlogic.org>
References: <20100616205111.GA8149@sles11sp1b1.qlogic.org>
 <4C1BFA2D.6050607@cs.wisc.edu>
 <AC192039-EAE9-4625-8AF0-C4B9E1C8D47D@qlogic.com>
 <4C20FD17.5040809@cs.wisc.edu>
 <39631C5E-052F-40D9-BA5B-442A939BE238@qlogic.com>
 <4C225ED6.6080309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:12098 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0GFFUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2010 01:20:50 -0400
In-Reply-To: <4C225ED6.6080309@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Thursday, June 24, 2010 12:52 AM
>To: Ravi Anand
>Cc: Vikas Chaudhary; james.bottomley@suse.de; linux-scsi@vger.kernel.org
>Subject: Re: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
>
>On 06/22/2010 03:55 PM, Ravi Anand wrote:
>> Thanks for the clarification. What about if we provide a cmd line option
>> for user's to fine tune if needed, with default value set.
>> Sound's OK ?
>
>iscsi recovery_tmo/replacement_tmo is the same as FC's fast_io_fail_tmo.
>So I think we want to make recovery_tmo/replacement_tmo's sysfs file
>writable, so tools like multipath/multipathd can set it like they do for
>fast_io_fail.

I added support in iscsi midlayer to modify recovery_tmo from sysfs.
I am sending rfc patches for the same in the next email.
Please review and let us know what you think.
