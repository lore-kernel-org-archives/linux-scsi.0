From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: 25 Nov 2003 03:21:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq0ptfgj1tp.fsf@wildopensource.com>
References: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:2231 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S262110AbTKYIYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 03:24:52 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598D30@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

>>>>> "Andrew" == Andrew Vasquez <andrew.vasquez@qlogic.com> writes:

Andrew> The (additional-)firmware options, perhaps a subset, seem like
Andrew> a (possibily) reasonable thing to force at the driver level.
Andrew> But, on the otherhand, the retry, delay and timer counts tend
Andrew> to be very customer specific based on topology and storage.
Andrew> Additionally, the driver already exports via module parameters
Andrew> several of the more important driver retry and timer counts,
Andrew> i.e. port_down_try_count, link_down_timeout, retry_count (try
Andrew> modinfo for a full list).  A user can use these facilities to
Andrew> perform any fine-tuning.

Andrew,

I would be a nice feature if all these tuning parameters were exported
via sysfs in 2.6 allowing users to modify them at runtime without
having to reload the module every time. It would be very useful to
test tuning parameters etc.

Cheers,
Jes
