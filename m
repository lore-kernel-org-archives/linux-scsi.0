From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: Fri, 10 Oct 2003 10:56:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031010085652.GJ7431@chihiro.cern.ch>
References: <Pine.LNX.4.58.0309260858210.1793@filesrv1.baby-dragons.com> <03Sep26.132713edt.332206@cyborg.cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.cern.ch ([137.138.131.164]:21224 "EHLO smtp3.cern.ch")
	by vger.kernel.org with ESMTP id S262732AbTJJI5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 04:57:16 -0400
Content-Disposition: inline
In-Reply-To: <03Sep26.132713edt.332206@cyborg.cybernetics.com>
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: "'Mr. James W. Laferriere'" <babydr@baby-dragons.com>, 'Jes Sorensen' <jes@wildopensource.com>, linux-scsi@vger.kernel.org

* Tony Battersby (tonyb@cybernetics.com) [20030926 13:27]:

> Yes, this is an old problem that keeps coming up.  See:
> http://marc.theaimsgroup.com/?t=3D101018223200001&r=3D1&w=3D2
> http://marc.theaimsgroup.com/?t=3D106074664100005&r=3D1&w=3D2

Thanks.  Finally, the workaround is to run in narrow mode since
our drives are capable of 15MB/s maximum.

Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
