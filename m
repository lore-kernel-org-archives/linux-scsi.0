From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCHv5 0/9] New EH command timeout handler
Date: Tue, 3 Sep 2013 12:36:58 -0400
Message-ID: <20130903163655.GA26642@logfs.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
 <20130902082728.GA15554@infradead.org>
 <52245235.9020408@suse.de>
 <20130902093129.GA17201@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60154 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab3ICSLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 14:11:36 -0400
Content-Disposition: inline
In-Reply-To: <20130902093129.GA17201@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On Mon, 2 September 2013 02:31:29 -0700, Christoph Hellwig wrote:
>=20
> I would defintively love enabling it globally.

Agreed.  I carry a private patch based on an older version of Hannes'
patchset doing just that.  Istr there was some problem exactly once on
a VM with a virtualized hba.  We hit problems with virtualized
ethernet devices fairly regularly, so a single case on scsi may simply
be some other latent bug.

On real hardware there have never been problems other than the scsi
aborts themselves.

J=C3=B6rn

--
Do not stop an army on its way home.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
