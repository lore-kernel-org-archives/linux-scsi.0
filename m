From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: Poisoning of Linux initiators on SCST reboot.
Date: Fri, 25 Jul 2008 15:11:25 +0200
Message-ID: <200807251511.26087.stf_xl@wp.pl>
References: <200807241750.m6OHophm028516@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:32794 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbYGYNSM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 09:18:12 -0400
In-Reply-To: <200807241750.m6OHophm028516@wind.enjellic.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: greg@enjellic.com
Cc: scst-devel@lists.sourceforge.net, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, vst@vlnb.net

Thursday 24 July 2008 19:50:51 greg@enjellic.com napisa=C5=82(a):
> As we began forced failure testing one issue has come up that I wante=
d
> to advise people of.  A hard reboot of an SCST target server results
> in the 'poisoning' of Linux based initiators.  We verified the issue
> as being present on client initiators running the stock RHEL5 kernel
> up through 2.6.26.
>
> The targets are using Qlogic 2462 cards using the isp_mod driver.  Th=
e
> client initiators are using Qlogic 2342 cards with the qla2xxx driver=
=2E
[snip]
> Any suggestions on how to move forward would be appreciated.  We've
> got a pretty extensive test environment and would be happy to test ru=
n
> any suggested changes or patches.
You may try isp_mod driver working in initiator mode (best compiled in=20
initiator role only) to see how it cope with such situation.

Cheers
Stanislaw Gruszka
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
