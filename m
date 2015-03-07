From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/21] lpfc: Fix premature release of rpi bit in bitmask
Date: Sat, 07 Mar 2015 09:11:42 -0800
Message-ID: <1425748302.2969.15.camel@HansenPartnership.com>
References: <1423164309.7917.38.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41921 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbbCGRLo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2015 12:11:44 -0500
In-Reply-To: <1423164309.7917.38.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2015-02-05 at 14:25 -0500, James Smart wrote:
> ---

This is a bit big for an empty explanation.  You're adding a lot of
unexplained debug statements, but your own words in the comment seem to
be the best changelog:

> + * lpfc_sli4_unreg_rpi_cmpl_clr - mailbox completion handler
> + * @phba: Pointer to HBA context object.
> + * @pmb: Pointer to mailbox object.
> + *
> + * This function is the unreg rpi mailbox completion handler. It
> + * frees the memory resources associated with the completed mailbox
> + * command. An additional refrenece is put on the ndlp to prevent
> + * lpfc_nlp_release from freeing the rpi bit in the bitmask before
> + * the unreg mailbox command completes, this routine puts the
> + * reference back.

I know its in the code, but the reason we have changelogs is so that
when distros ask "is this fixed upstream" they can look through the git
log for the driver to get an idea.  For them you need to say that this
is SLI rev 4 only and then give the above explanation.

James


