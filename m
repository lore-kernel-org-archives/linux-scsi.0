From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] qla_target: Check refcount in find_sess_by_*
Date: Fri, 18 May 2012 18:49:50 -0400
Message-ID: <20120518224948.GB21634@logfs.org>
References: <20120511143341.GA18753@logfs.org>
 <20120517162600.GA18067@logfs.org>
 <1337283995.32217.233.camel@haakon2.linux-iscsi.org>
 <CAL1RGDUmT4xOQQkAE5eq-XXZa5b64SeTZjfcWdeuMiUu=DRarg@mail.gmail.com>
 <20120517192830.GC18067@logfs.org>
 <20120517210521.GE18067@logfs.org>
 <1337306556.32217.365.camel@haakon2.linux-iscsi.org>
 <20120518011528.GG18067@logfs.org>
 <1337321367.32217.412.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:47786 "EHLO
	longford.logfs.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754420Ab2ESAzp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 20:55:45 -0400
Content-Disposition: inline
In-Reply-To: <1337321367.32217.412.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@purestorage.com>, target-devel@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Steve Hodgson <steve@purestorage.com>

On Thu, 17 May 2012 23:09:27 -0700, Nicholas A. Bellinger wrote:
>=20
> So that means your testing with it now, right..?

Our kernel has diverged too much from yours to easily move patches
back and forth, so no.

But more importantly, we still don't have a complete patchset.

J=C3=B6rn

--
The only real mistake is the one from which we learn nothing.
-- John Powell
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
