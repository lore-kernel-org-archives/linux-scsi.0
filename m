Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.3.219.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793196160;
	b=kq1jnpBjyg8Whr+TmGDDVduYLr0By6cBFnM2Rjj3t0lwoCULp+uHwjxxtJxcGdvdbkXx
	 b3lcxIw5yiUwbe/0EZMJv10hYN1Boa3E2gTrhjh5nd8Rozt+VTKdDBYtiWJs09GocHKEV
	 WCVeaGk7LKFnywa/rRAJrb2B1BumDFck6TFRwRkwRj3mi8khmT09i3Q1cHxy3AbM6zw3v
	 2NOz5jiABMfKj9x55REwfprOlRWmhaz/tShSK9JVsT49WWjshtLFx7ui2OxxFhiXto2Ro
	 i14dcNrmfuCsxz6Xi7DU3Vqz6XKcyT9oOBYWK0jXa5R+68TYj62Qo02ttJVvXS34tIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793196160;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:DKIM-Signature:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Originating-IP:
	 X-ClientProxiedBy:X-KSMG-AntiPhishing:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:X-KSMG-KATA-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=6qa2C8sCvrTQ2ETgMYfY5rx37DEoDs+XYsH6Tphrrvg=;
	b=T+o/o0V4yUSwu9p8fDoVN7BwEJgPUBmtP0Z6cTqQQnspD/uBrKjZ3QlbuU6uhHh/28Ey
	 vfOGv25WkHHnOQLWOPTNjyxgmX54QbZ/CzTGG7yChrhVq2k379Xey6e1pozUDGVunCBFI
	 ZcmqLcIEv3w3vWCHtaZe3uySXYAtp7emnXOihhxTeDB05zBXSy3ieU/6kadp+OOXJ2Dyz
	 /5ElilYQyoQq8hg2E+nVs6+D7XDbtXmhLFINAjW4E8aRJiRIK0l/LFhhHKRjfTvmqweIE
	 +RKhNPx0RAiwcH9S6nVdaDMgbG63vi9e0oa6Etwlde5SWg/ckuceIbqKAwss0rrRuFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yadro.com;
	spf=pass smtp.mailfrom=yadro.com;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=slSp5xR5;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=rKtjQHwz;
	arc=none smtp.remote-ip=195.3.219.148
Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538E5606A31A;
	Wed, 28 Oct 2026 14:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 538E5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=slSp5xR5;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=rKtjQHwz
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 0BF5120026;
	Wed, 28 Oct 2026 17:02:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 0BF5120026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1793196152; bh=6qa2C8sCvrTQ2ETgMYfY5rx37DEoDs+XYsH6Tphrrvg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=slSp5xR5A8llQRG6YfZ6316njzfmOHIxD4+Mhv5FC8TOquqTU0JDKN/nR2614wOEL
	 SBHDauu1cvo/G1cgMFMMBdP8wQTGB96TYvn4sbg/Q0WoRwdhYIcMC5lGlxq4++2uDR
	 vsr+tj0SjLbiWe4twvZdt0X0+NZlRTbp9Q3dByTDoddxPyqwruUhJCyIryIEANGzdP
	 6Wt89xeIJBdn+AenHhhaYNNlDnbNRDa8l7aGpMEh8PnFNX00Z7ZLrduF0LvDONRa6T
	 yRkIU8Lj2+fbixcqgtGWQi40VOYzeLZmmkhjbCj+fwZiFiZk68PobKEevxVFSe5GuO
	 v1+K2wlz3I6Ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1793196152; bh=6qa2C8sCvrTQ2ETgMYfY5rx37DEoDs+XYsH6Tphrrvg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=rKtjQHwzmn2IhSe1N/1DuKOxizk4qPOklcKt4y6THxexFwQL4V4/zkQym+0vtXIoP
	 wdkgFQHTnkcHmh1jLyKKTj3FcWTyYhPl3d5LeRfQEbTIPtagW8H3WHNT7GsjRouGm6
	 NdJXiZrreF3ebsI3k2DwCBMbIf0Vjj6C9SuxgCBlE/uZaS45XNzbF8OllqH8bQh7XP
	 T6ht5u+h6fGolafvoEfSmEezSpTgBkEMlX4SWdCK+jfxEjrb8QIom1y4Q0fsYAS5jz
	 m2kc2BzGKPAk5BjC8YOBi0yYu8S1b4CH6OHlE47+elLGPU2OPL4k2gaDywG9L3oup7
	 YCt6YmVZdhA1Q==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Wed, 28 Oct 2026 17:02:21 +0300 (MSK)
Received: from yadro.com (10.34.9.247) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 28 Oct
 2026 17:02:21 +0300
Date: Wed, 28 Oct 2026 17:02:21 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Laurence Oberman <loberman@redhat.com>
CC: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	<mlombard@redhat.com>, <target-devel@vger.kernel.org>,
	<michael.christie@oracle.com>, <linux-scsi@vger.kernel.org>,
	<linux@yadro.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
Message-ID: <20261028140221.GB32229@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected, bases: 2026/10/28 13:11:00
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/10/28 07:15:00 #28752282
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected, bases: 2026/10/28 13:11:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

Hi Laurence,

On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> 
> On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > ISCSI has some old leftovers in the code that prevents passing the
> > aborted
> > command to the target core to make the actual abort. Such commands
> > hang
> > until connection is closed.
> > So remove those leftovers.
> >
> > Dmitry Bogdanov (2):
> >   Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
> >     commands"
> >   scsi: target: iscsi: fix hanging WRITE_PENDING commands
> >
> >  drivers/target/iscsi/iscsi_target.c      | 19 -------------------
> >  drivers/target/iscsi/iscsi_target_erl1.c |  8 --------
> >  2 files changed, 27 deletions(-)
> 
> Hello Dmitri
> Thanks for posting this. I have a series in flight for the same hang:
> 
> https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@redhat.com/

I know, that is why both you and Maurizio in To: field. I want from
you some comments. Thank you for review.

> 
> Is the revert maybe aimed at the wrong layer, and the sashiko review of
> your 2/2 makes the case better than I can: with the fabric check
> removed, an aborted command reaches target_execute_cmd(),
> target_cmd_interrupted() queues target_abort_work and returns without
> changing t_state, the command stays on conn_cmd_list in
> TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
> completes it a second time if the connection closes.

As I said in response to sashiko-bot, that is the current (always be) behavior.
It is not introduced by my patch.

> That is the same double completion you are reverting d5869dae5080 for.
> It
> is not a defect in Maurizio's patch and it will not be fixed by
> replacing
> it -- target_cmd_interrupted() records nothing when it queues an abort,
> so
> any site that completes an aborted WRITE_PENDING command can be
> followed
> by another one. I found this from vmcores on a customer system before
> either of us posted, so no argument from me that it is real.

Not the same, d5869dae5080 greatly increases the probability of the
double completion by calling target_complete_cmd() which is allowed to be
called only once for the cmd. Calling it twice is wrong by nature. Fabric
module shall call either target_execute_cmd() either
transport_generic_request_failure(). target_complete_cmd() is for
backstore modules. That target_complete_cmd() at the iscsi
connection release is not so good too. But it was intended to be the
last(and the only) call from fabric driver for the command never be in
the target core.

> 
> Patch 3 of my series fixes it there, under t_state_lock, for both
> queueing sites in target_core_transport.c and for every fabric. With
> that
> in place your 2/2 is safe and d5869dae5080 does not need reverting for
> this reason -- which matters, because the revert is not free: that
> commit
> carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
> 6.18.y and 7.2.y.

My intention is to not create a situation when there a race is possible
instead of fixing those races. 

> Two questions on 2/2 independent of all that.
> 
> Removing the sense_reason early return in iscsit_execute_cmd() means
> transport_send_check_condition_and_sense() now runs for an aborted
> command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
> CMD_T_ABORTED, and ends in queue_status(); target_handle_abort() also
> calls queue_status() for a CMD_T_TAS command, and each drops a
> reference.
> Can an aborted command with a sense reason send both a CHECK CONDITION
> and a TASK ABORTED, and drop two references?

No, transport_send_check_condition_and_sense will change t_state, send
status and decrease cmd->refcnt and then unblock wait_for_completion of
ABORT/LUN_RESET. Both the commnand and ABORT of that command will be
completed sucessfully.
Noone calls target_handle_abort().

> And with the early return gone, a LUN_RESET aborting a large WRITE
> waits in target_put_cmd_and_wait() for the whole remaining data
> transfer. That is bounded where today it is not, but on a large
> transfer it may still trip the hung task timeout that made this
> visible.
 
That is a idea for a future discussion and improvmens. This patchset is
narrowed to just to fix the stuck of WRITE_PENDING commands.

The abort of WRITE_PENDIG command in the state waiting for DataOuts
currently will wait for the data completion. So, my patch again does not
do worse.

> On the overlap: your 2/2 and patch 4 of my series touch the same lines,
> so only one can apply, and I have no attachment to mine if yours is the
> better shape. Patches 1 to 3 are core-side and conflict with nothing
> you have posted.
> 
> Martin, would you prefer those three as their own series,
> given both candidate iSCSI fixes need patch 3 to be correct?
> 
> I am happy to test either or both: I have a reporter's environment that
> reproduces this reliably and 300-cycle runs on it.

My patch is more than 2 years old in customers setups, but certainly
it would be great to test it in other environments too.

BR,
 Dmitry
