From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH, RFC] sym2: remove unkown data direction handling
Date: Tue, 2 Nov 2004 12:46:33 -0500
Message-ID: <04Nov2.124609est.332219@cyborg.cybernetics.com>
References: <20041102171511.GA1810@lst.de>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:63494 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S261232AbUKBRqN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 12:46:13 -0500
In-Reply-To: <20041102171511.GA1810@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, 'Matthew Wilcox' <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

> > I thought we could get an unknown data direction from certain
ioctls?
>
> Not anymore.  We could get the wrong direction from some older ioctls,
> when not used as document but not an unkown one.

Isn't it still possible for a userspace program to specify
SG_DXFER_UNKNOWN when sending a command via /dev/sg* (not that it's a
good idea, but...)

http://gear.torque.net/sg/p/sg_v3_ho.html#AEN166

If you want to BUG() on an unknown data direction, then sg should return
an error to userspace when it sees SG_DXFER_UNKNOWN to avoid the BUG().

Anthony J. Battersby
Cybernetics

