From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix lpfc_parse_bg_err()'s use of do_div()
Date: Tue, 14 Apr 2009 17:12:03 +0100
Message-ID: <28206.1239725523@redhat.com>
References: <49E4B51E.3040402@emulex.com> <20090414155948.27755.2131.stgit@warthog.procyon.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33094 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbZDNQNm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2009 12:13:42 -0400
In-Reply-To: <49E4B51E.3040402@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: dhowells@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

James Smart <James.Smart@Emulex.Com> wrote:

> I already posted the same fix on 4/7. See:
> http://marc.info/?l=linux-scsi&m=123912745216961&w=2

Fair enough.  Feel free to add my Acked-by.

David
