From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Fri, 14 Apr 2006 06:19:22 -0400
Message-ID: <443F772A.3080302@emulex.com>
References: <1144693508.3820.33.camel@localhost.localdomain> <443B2A79.4020600@cs.wisc.edu> <443E6ADC.8080206@emulex.com> <443F23D7.9090000@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:29605 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S965134AbWDNKTg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 06:19:36 -0400
In-Reply-To: <443F23D7.9090000@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org


> Actually, maybe, I should not have brought this up as it could just be
> more of a workaround of the core problem. For FC in fc_user_scan() do
> you need some sort of lock around the rport loop?

Yes, I had noticed this as well. However, I don't think this is influencing
the deadlock.

-- james s
