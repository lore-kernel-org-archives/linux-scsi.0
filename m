From: Jes Sorensen <jes@sgi.com>
Subject: Re: qla1280: failing mbox check
Date: 12 May 2006 03:26:48 -0400
Message-ID: <yq04pzvr9dz.fsf@jaguar.mkp.net>
References: <446409CA.2090100@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:32407 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750754AbWELH0u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 03:26:50 -0400
In-Reply-To: <446409CA.2090100@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kumba <kumba@gentoo.org>
Cc: linux-scsi@vger.kernel.org

>>>>> "Kumba" == Kumba  <kumba@gentoo.org> writes:

Kumba> Any ideas where to start looking or things to try?  2.6.16.*
Kumba> works flawlessly, and I didn't see anything odd done to
Kumba> qla1280.c itself that could be the point of breakage.  So I can
Kumba> only assume that the error is in a higher-level somewheres.

'git bisect' is your friend here.

Cheers,
Jes
