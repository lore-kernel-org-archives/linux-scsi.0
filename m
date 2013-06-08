From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 1/9] target: Add transport_cmd_check_stop write_pending
 bit
Date: Sat, 8 Jun 2013 00:00:36 -0400
Message-ID: <20130608040035.GA2580@logfs.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
 <1370640864-15568-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59468 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3FHF3y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jun 2013 01:29:54 -0400
Content-Disposition: inline
In-Reply-To: <1370640864-15568-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>

On Fri, 7 June 2013 21:34:16 +0000, Nicholas A. Bellinger wrote:
> =20
> -static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_=
from_lists)
> +static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_=
from_lists,
> +				    bool write_pending)
=2E..

> -	return transport_cmd_check_stop(cmd, true);
> +	return transport_cmd_check_stop(cmd, true, false);

At this point I would prefer to pass in a flags.
transport_cmd_check_stop(cmd, SC_REMOVE_FROM_LISTS) seems more
readable to me.

The rest of the patchset I rather like.  Well done.

J=C3=B6rn

--
When you close your hand, you own nothing. When you open it up, you
own the whole world.
-- Li Mu Bai in Tiger & Dragon
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
