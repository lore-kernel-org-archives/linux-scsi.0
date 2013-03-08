From: Roland Dreier <roland@kernel.org>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Thu, 7 Mar 2013 20:14:58 -0800
Message-ID: <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52207 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759407Ab3CHEPU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Mar 2013 23:15:20 -0500
In-Reply-To: <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Thu, Mar 7, 2013 at 5:45 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> +EXPORT_SYMBOL(iscsit_get_transport);

It's not clear to me why this needs to be exported.  Who would use it
outside the core iscsi target module?
