From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/11] qla4xxx: set correct value in sess->recovery_tmo
Date: Wed, 23 Jun 2010 14:21:58 -0500
Message-ID: <4C225ED6.6080309@cs.wisc.edu>
References: <20100616205111.GA8149@sles11sp1b1.qlogic.org> <4C1BFA2D.6050607@cs.wisc.edu> <AC192039-EAE9-4625-8AF0-C4B9E1C8D47D@qlogic.com> <4C20FD17.5040809@cs.wisc.edu> <39631C5E-052F-40D9-BA5B-442A939BE238@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59480 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab0FWTTY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jun 2010 15:19:24 -0400
In-Reply-To: <39631C5E-052F-40D9-BA5B-442A939BE238@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 06/22/2010 03:55 PM, Ravi Anand wrote:
> Thanks for the clarification. What about if we provide a cmd line option
> for user's to fine tune if needed, with default value set.
> Sound's OK ?

iscsi recovery_tmo/replacement_tmo is the same as FC's fast_io_fail_tmo. 
So I think we want to make recovery_tmo/replacement_tmo's sysfs file 
writable, so tools like multipath/multipathd can set it like they do for 
fast_io_fail.
