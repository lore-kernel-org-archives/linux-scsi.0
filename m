From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 1/4] scsi: move initialization of scmd->eh_entry
Date: Thu, 6 Jun 2013 12:14:04 -0400
Message-ID: <20130606161404.GB16616@logfs.org>
References: <1370511835-50072-1-git-send-email-hare@suse.de>
 <1370511835-50072-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59407 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FFRnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jun 2013 13:43:20 -0400
Content-Disposition: inline
In-Reply-To: <1370511835-50072-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, 6 June 2013 11:43:52 +0200, Hannes Reinecke wrote:
>=20
> The 'eh_entry' list might be used even before scsi_softirq_done()
> is called. Hence we should rather initialize it together with
> the other eh-related variables.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Tested-by: Joern Engel <joern@logfs.org>

J=C3=B6rn

--
It is better to die of hunger having lived without grief and fear,
than to live with a troubled spirit amid abundance.
-- Epictetus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
