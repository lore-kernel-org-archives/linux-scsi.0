From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 1/23]: SCST public headers
Date: Wed, 10 Dec 2008 21:28:30 +0300
Message-ID: <49400A4E.7040107@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYLJS3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:29:04 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains declarations of all externally visible constants, 
types and functions prototypes.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  include/scst/scst.h       | 2676 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  include/scst/scst_const.h |  316 ++++++
  2 files changed, 2992 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_public_headers.diff


