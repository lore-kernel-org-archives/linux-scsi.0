From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 0/4] New SCSI command timeout handler
Date: Fri, 7 Jun 2013 12:02:52 -0400
Message-ID: <20130607160252.GA25323@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <51B18398.6000508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59444 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3FGRcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 13:32:13 -0400
Content-Disposition: inline
In-Reply-To: <51B18398.6000508@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Fri, 7 June 2013 14:54:16 +0800, Ren Mingxin wrote:
> On 06/06/2013 05:43 PM, Hannes Reinecke wrote:
>=20
> This approach may not work for some LLDDs as you said, but I wonder
> whether SAS is applicable(whether there will be later patches for
> SAS).

We have tested a derived patch on SAS and it did improve things.

J=C3=B6rn

--
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
