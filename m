From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 05/13] qla4xxx: Fix exporting boot targets to sysfs
Date: Mon, 03 Oct 2011 15:46:56 -0500
Message-ID: <4E8A1F40.2030208@cs.wisc.edu>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com> <1317662967-30110-6-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43261 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195Ab1JCUlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 16:41:47 -0400
In-Reply-To: <1317662967-30110-6-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> 
> The driver failed to export primary boot target if secondary target did not
> exist in the FLASH. If boot targets are not valid then driver assumed 0 and
> 1 as default boot targets. Since these target did not exist in flash, the
> driver failed exporting all the targets.
> Also fixed,
> - for 8022 calculate max chap entries based on the size of CHAP table in FLASH
> - If a boot target has a BIDI CHAP enabled, then read the user/secret from
> CHAP table. Do not assume BIDI chap at peer CHAP idx + 1

You would normally want to send that in another patch.


> +/**
> + * qla4xxx_get_bidi_chap - Get a BI-DI CHAP user and secret.
> + * @ha: pointer to adapter structure
> + * @username
> + * @password
> + *

Forgot to add a description again.

You can probably just ask James if it would be ok to send a patch to fix
them all up over this patchset so you do not have to resend patches.
