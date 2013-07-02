From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Tue, 2 Jul 2013 16:33:40 +0000
Message-ID: <1372782820.2821.18.camel@dabdike>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
	 <20130701174423.GA10645@logfs.org> <1372706605.2385.37.camel@dabdike>
	 <20130701205546.GB10645@logfs.org> <1372747024.2385.71.camel@dabdike>
	 <20130702145809.GA19005@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43657 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3GBQdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jul 2013 12:33:43 -0400
In-Reply-To: <20130702145809.GA19005@logfs.org>
Content-Language: en-US
Content-ID: <00861BA8D35E2347BAF22FF434B0C33E@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>

On Tue, 2013-07-02 at 10:58 -0400, J=F6rn Engel wrote:
> On Tue, 2 July 2013 06:37:05 +0000, James Bottomley wrote:
> >=20
> > I don't understand what you're getting at.  In a dual HBA situation=
,
> > whether the second HBA is implicated or not depends on configuratio=
n and
> > what the first HBA is doing. If it's just passively lost device sta=
te,
> > then the second HBA should continue just fine.  If the insane HBA i=
s
>=20
> If the problem is an insane drive instead of an insane HBA, both HBAs
> will be in roughly the same state at roughly the same time - assuming
> they both send commands to the insane drive.  If they now go into
> error handling and effectively shut off all the sane drives at roughl=
y
> the same time, the user is ****ed.

That's handled in device reset, so I don't understand your point.

James

> And we shouldn't require the user to buy better hardware.  The whole
> point of a redundant setup is that your plane doesn't crash to the
> ground when one of your two engines fails.  If regulations required
> perfect engines, you wouldn't be flying to conferences.  They require
> decent engines and enough redundancy that any one can fail at any
> moment.
>=20
> Computer systems are no different.  We can construct a robust system
> from individually less robust components.  Requiring perfect
> components would be ludicrous.  Having a system design where one
> faulty component will reliably bring the system down is equally
> ludicrous.  Sadly that is also the state of today's scsi stack.
>=20
> This is not a theoretical problem, btw.  We currently carry some
> patches to solve it for us.  They are not applicable for mainline in
> their current state - we support a lot less hardware diversity.  But
> trust me, we didn't create them on a whim. ;)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
