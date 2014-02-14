From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/16] scsi_dh_alua: Improve error handling
Date: Fri, 14 Feb 2014 12:32:54 +0100
Message-ID: <52FDFEE6.1040103@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-2-git-send-email-hare@suse.de> <52FDFAF9.3040409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaBNLc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 06:32:57 -0500
In-Reply-To: <52FDFAF9.3040409@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/14/2014 12:16 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> - * alua_stpg - Evaluate SET TARGET GROUP STATES
>> + * stpg_endio - Evaluate SET TARGET GROUP STATES
>=20
> Great that you are fixing the function header of stpg_endio(). But
> please consider to use here the official terminology from SPC ("SET
> TARGET PORT GROUPS").
>=20
Ok. Will be fixing it for the next round.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
