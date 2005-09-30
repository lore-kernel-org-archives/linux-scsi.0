From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: I request inclusion of SAS Transport Layer and AIC-94xx into
	the kernel
Date: Fri, 30 Sep 2005 19:53:57 +0200
Message-ID: <1128102837.3012.15.camel@laptopd505.fenrus.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44239 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932552AbVI3RyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 13:54:16 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: "Tuikov, Luben" <Luben_Tuikov@adaptec.com>, andrew.patterson@hp.com, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, 2005-09-30 at 13:07 -0400, Salyzyn, Mark wrote:
> At the SAS BOF, I indicated that it would not be much trouble to
> translate the CSMI handler in the aacraid driver to a similar sysfs
> arrangement. If such info can be mined from a firmware based RAID card,
> every driver should be able to do so. The spec writers really need to
> consider rewriting SDI for sysfs (if they have not already) and move
> away from an ABI.

that makes me wonder... why and how does T10 control linux abi's ??


