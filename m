From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 01/10] sg: remove unnecessary indentation
Date: Mon, 7 May 2012 15:44:50 -0400
Message-ID: <20120507194450.GC6553@logfs.org>
References: <20120412213217.GA17388@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:60108 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2EGVr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2012 17:47:27 -0400
Content-Disposition: inline
In-Reply-To: <20120412213217.GA17388@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Thu, 12 April 2012 17:32:17 -0400, J=C3=B6rn Engel wrote:
>=20
> blocking is de-facto a constant and the now-removed comment wasn't al=
l
> that useful either.  Without them and the resulting indentation the c=
ode
> is a bit nicer to read.

Ping.

This patchset, amongst other things, solves the issue of tasks hanging
for >200s.  Strictly those hung tasks were a regression introduced
when Arnd removed the BKL.  So someone should merge them.

James, would that someone be you?

J=C3=B6rn

--
tglx1 thinks that joern should get a (TM) for "Thinking Is Hard"
-- Thomas Gleixner
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
