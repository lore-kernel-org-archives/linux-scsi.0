From: Bernd Schubert <bs@q-leap.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Thu, 3 Apr 2008 13:13:21 +0200
Message-ID: <200804031313.22257.bs@q-leap.de>
References: <20080331150434.a3fb336b.taeuber@bbaw.de> <20080403123107.71d82746.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:42544 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbYDCLNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 07:13:24 -0400
In-Reply-To: <20080403123107.71d82746.taeuber@bbaw.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?iso-8859-1?q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

Hello Lars,

On Thursday 03 April 2008 12:31:07 Lars T=E4uber wrote:
> Hi!
>
> OK, I understand. Being ignored means having asked at the wrong place=
=2E
> Can someone give me a hint where to ask instead?

no, I think you did ask at the right place, but nobody does know what i=
s the=20
cause of the problem.
Well, from my point of view linux-scsi is by far to quiet in case of er=
rors. I=20
have patches for 2.6.22 to improve this situation and the error handler=
 in=20
general, but presently don't have the time to clean it up and to push i=
t=20
upstream.

If you would be willing to use 2.6.22 + my scsi patches we would at lea=
st find=20
out which scsi commands fail.

Eric also did sent me a more recent version of the MPT driver, it also =
might=20
be worth to try this version. It fixed a really troublesome mpt-scsi bu=
g for=20
us, but I don't know how well it works for SAS.


Cheers,
Bernd

--=20
Bernd Schubert
Q-Leap Networks GmbH
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
