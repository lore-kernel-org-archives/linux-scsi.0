From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/13] qla4xxx: Do not add duplicate CHAP entry in FLASH
Date: Mon, 03 Oct 2011 15:40:39 -0500
Message-ID: <4E8A1DC7.8040803@cs.wisc.edu>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com> <1317662967-30110-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36847 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1JCUfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 16:35:30 -0400
In-Reply-To: <1317662967-30110-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
> 
> QLogic applications store the CHAP information in FLASH. During login,
> authentication information is provided using an index into the CHAP region.
> 
> In order to support QLogic applications along with iscsiadm, updated the
> LLD to not add duplicate CHAP entries in the CHAP region and preserve the
> existing CHAP info in the CHAP region in FLASH.
> This allows QLogic applications to pre-write the CHAP entries in the CHAP
> region.
> 
> With iscsiadm, when the CHAP authentication information is sent to the LLD, the
> LLD searches for the entry in CHAP region in FLASH, if exists then do not add.
> If CHAP entry does not exist then add the CHAP entry in the CHAP region.
> 

Does the qlogic app use the bsg flash commands to send down everything
then or how does one app work differently and use the same driver for
everything else?


> +/**
> + * qla4xxx_get_chap_index - Get chap index given user name and secret
> + * @ha: pointer to adapter structure
> + * @username
> + * @secret

You forgot to write some info on those arguments.
