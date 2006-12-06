From: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Subject: Re: problems to expect with >2TB volumes
Date: Wed, 6 Dec 2006 11:37:59 +0100
Message-ID: <200612061137.59655.bernd.schubert@pci.uni-heidelberg.de>
References: <ekkmug$kmu$1@sea.gmane.org> <456DF3C9.6060004@torque.net>
Reply-To: bernd-schubert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:60836 "EHLO
	relay.uni-heidelberg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463AbWLFKiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 05:38:06 -0500
In-Reply-To: <456DF3C9.6060004@torque.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hello Douglas,

thanks for your help, I was just a bit worried when I read  the thread.

> On reviewing that thread, the original poster was
> jumping to premature conclusions. Justin Gibbs told
> him there was no such problem (and Justin is well
> placed to know). Then the final post shows a trace
> with READ(10) commands failing. They are 32 bit lba
> read operations that have been the default for about
> 10 years in the SCSI subsystem. If those fail on that
> transport it is probably a termination problem.
> When Justin saw that he probably didn't bother
> responding again.

=46or a non-scsi protocol expert those scsi card dumps really don't say=
=20
anything :(

Thanks again,
Bernd

--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
