Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821542;
	b=LuRDbM5Cqj6iyyoIUbAaNTCk/YWL546UeAnAxdCM3qy9eUiFD5qw9VtgMURNjgDN7Ecf
	 defPXbwr8kyIOfKkE2Orxd95lurvd5Badpj/CkfNwCjLRyuqzNmTw23XrCPB4qmOGKsOx
	 kSdX40Y54Fy2SMi0sHMCK+whDFRTFVaAOv115REcPGyDZ863SU4itQX674dS9Bt310Asl
	 yEN14qTLMRrcHBCD6owUY3f99yg6iz3nJXMAB9nT8vUsDV5rvFRGqvo4se3IpT4oYSfd8
	 +b1/bL0cS99qEByM40QrQjliiHv4gTGgRF+IHNA8E1M+CANugtnww4V5Pje9Ie9iHXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821542;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=lcn8lAsuotQDYeJ8+Vj1I/oVGm0BeS8QPGRvFdgRHjc=;
	b=I5lJZPeCC9ISjLEhEEeT+1LFg0w78ilz1pb81HvrX1l4goKEidvIjOGPL0tLDGCaFPe7
	 nQrsvKr29EQyOf9K0rrhh1dKHcQCHonVQ739vc+3l5lOUFx32uPLNMLLlrh8b4mCS9JR0
	 XHWBjhaDr3yCxozOTOKxjm7f7iarl3oDq2xb2Vb2r2EvLNZ3MOXEC5AlrsZddYWVNK/WM
	 ZwHdVDMcObsPplf6jo0KYOuUHDjWwVOyK1NdEc0oK0XoRwWko3u8DpefU/+4COH7YBLu7
	 j83eT5EIUNlq2VnrFDcWJGpTH0C3A3DohFBdi5Kr/EkrwiRyHx9ctpSQPrhGd4To4lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TMKuaW8f;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="YY5vPV/Z";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19681606A32F;
	Mon, 16 Nov 2026 09:32:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19681606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=TMKuaW8f;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YY5vPV/Z
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC9F41FCED;
	Mon, 16 Nov 2026 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794821540; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lcn8lAsuotQDYeJ8+Vj1I/oVGm0BeS8QPGRvFdgRHjc=;
	b=TMKuaW8fxlu+p6TKZxQVB3z0in3/h6lEQKagQ/1j71Voqyh08apglQVMeJHqqSwChvwl0S
	jRxD3sxpuXEHzSMLQJjvtsIZqmmLgMRcfOUyXAEY6tx9/ezz31v2usCvttkx8tdqRO5QfS
	/40MbBZVipq28JAJIJHoioQ4Ml8Dg7U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="YY5vPV/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794821539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lcn8lAsuotQDYeJ8+Vj1I/oVGm0BeS8QPGRvFdgRHjc=;
	b=YY5vPV/ZqSiOognNU7rhtBOVUKRdhIAlpeEIyqXtczBQ2pqUgjm2JrgJkapXmdIDbo3krc
	0QvPeVbuZJq9SCf7lvgEPdcWpbJwzJIh3oEdLRs2hKwTgTz31YzXaPsbEHmXNwRb+Z+HfT
	DhNGmZj696wKun9U3CJlGCYerKXW1ys=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D98313408;
	Mon, 16 Nov 2026 09:32:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 27cuFKPN+moBKwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Nov 2026 09:32:19 +0000
Message-ID: <bf50fd2197cffbad48ff39e3c97e2ab9599c4d99.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: set handler_data before
 alua_initialize()
From: Martin Wilck <mwilck@suse.com>
To: Laurence Oberman <loberman@redhat.com>, John Garry
 <john.garry@linux.dev>,  "Martin K . Petersen"	 <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@kernel.org>,
 linux-kernel@vger.kernel.org, 	stable@vger.kernel.org
Date: Mon, 16 Nov 2026 10:32:18 +0100
In-Reply-To: <57f9665fb8c3571cff55b2fafceec7437634fd5d.camel@redhat.com>
References: <20261109201120.1067815-1-loberman@redhat.com>
		 <37cb0b01-0c6a-4b3d-b3d8-c4e5a45977a8@linux.dev>
	 <57f9665fb8c3571cff55b2fafceec7437634fd5d.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: EC9F41FCED

On Sun, 2026-11-15 at 14:37 -0500, Laurence Oberman wrote:
> On Sun, 2026-11-15 at 18:04 +0000, John Garry wrote:
> > On 11/9/26 20:11, Laurence Oberman wrote:
> > > Since commit 50759b881e1d ("scsi: device_handler: alua: Call
> > > scsi_device_put() from non-atomic context"), alua_rtpg_queue()
> > > only
> > > queues an RTPG when sdev->handler_data points at an alua_dh_data
> > > whose
> > > port group matches:
> > >=20
> > > =09struct alua_dh_data *h =3D sdev->handler_data;
> > > =09...
> > > =09if (h && rcu_dereference(h->pg) =3D=3D pg) {
> >=20
> > Do we still require this check (for h being non-NULL) after the
> > change=20
> > in this patch? I assume that we flush any calls to this function
> > prior=20
> > to unsetting sdev->handler_data.
> >=20
> > >=20
> > > However alua_bus_attach() only assigns sdev->handler_data after
> > > alua_initialize() returns, and alua_initialize() ->
> > > alua_check_vpd()
> > > is where the initial RTPG is queued. At that point handler_data
> > > is
> > > still NULL, so the initial RTPG is silently dropped: no RTPG is
> > > sent,
> > > nothing is logged, and sdev->access_state keeps its zeroed
> > > default
> > > of
> > > active/optimized for every path.
> > >=20
> > > With dm-multipath this goes unnoticed, as pg_init calls
> > > scsi_dh_activate() once the map is loaded, which queues an RTPG
> > > after
> > > handler_data is set, and multipathd's alua prioritizer issues its
> > > own
> > > RTPG from userspace. Anything relying on sdev->access_state
> > > without
> > > a
> > > subsequent activate (sysfs access_state/preferred_path, native
> > > SCSI
> > > multipath path selection) sees every path as active/optimized
> > > until
> > > a
> > > Unit Attention or rescan triggers an RTPG.
> > >=20
> > > Seen on an HP P2000 G3 FC array (implicit ALUA, two port groups,
> > > four
> > > paths per LUN) with dm-multipath not in use: sg_rtpg reports port
> > > group
> > > 0 active/non-optimized and port group 1 active/optimized, but
> > > /sys/class/scsi_device/H:C:T:L/device/access_state reads
> > > active/optimized on all four paths after boot, and no
> > > "alua: port group XX state ..." message is logged. Writing
> > > "activate"
> > > to dh_state sends the RTPG and corrects access_state.
> > >=20
> > > Kernels without commit 50759b881e1d queue the attach-time RTPG
> > > unconditionally and are not affected.
> > >=20
> > > Fix by assigning sdev->handler_data before calling
> > > alua_initialize(),
> > > and clearing it again on failure. sdev->handler is only set once
> > > scsi_dh_handler_attach() sees ->attach() succeed, so no handler
> > > callback can observe the partially initialised alua_dh_data. On
> > > the
> > > failure paths of alua_initialize(), h has not been added to a
> > > port
> > > group and no RTPG has been queued, so freeing it is unchanged.
> > >=20
> > > Fixes: 50759b881e1d ("scsi: device_handler: alua: Call
> > > scsi_device_put() from non-atomic context")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> > > ---
> > >=20
> > > Notes:
> > > =C2=A0=C2=A0=C2=A0=C2=A0 Tested on an HP P2000 G3 FC array (30 LUNs, =
4 paths each):
> > > with this
> > > =C2=A0=C2=A0=C2=A0=C2=A0 patch the "alua: port group 00 state N ..." =
messages are
> > > logged during
> > > =C2=A0=C2=A0=C2=A0=C2=A0 boot and access_state shows two active/optim=
ized and two
> > > =C2=A0=C2=A0=C2=A0=C2=A0 active/non-optimized paths per LUN without a=
ny manual
> > > activate.
> > > =C2=A0=C2=A0=C2=A0=C2=A0 Without it, all paths read active/optimized =
until an RTPG is
> > > triggered.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0 I found this while testing John Garry's nati=
ve SCSI
> > > multipath
> > > series
> > > =C2=A0=C2=A0=C2=A0=C2=A0 (v9) on an HP P2000 G3 FC array (30 LUNs, 4 =
paths each, dm-
> > > multipath
> > > =C2=A0=C2=A0=C2=A0=C2=A0 not in use). Native multipath uses sdev->acc=
ess_state for
> > > path
> > > =C2=A0=C2=A0=C2=A0=C2=A0 selection, and every path showed active/opti=
mized, although
> > > sg_rtpg
> > > =C2=A0=C2=A0=C2=A0=C2=A0 and dm-multipath (alua prio 50/10) both repo=
rt port group 0
> > > as
> > > =C2=A0=C2=A0=C2=A0=C2=A0 active/non-optimized. No "alua: port group X=
X state ..."
> > > message was
> > > =C2=A0=C2=A0=C2=A0=C2=A0 logged at boot. Writing "activate" to dh_sta=
te corrected
> > > access_state,
> > > =C2=A0=C2=A0=C2=A0=C2=A0 which pointed at the attach-time RTPG never =
being queued.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0 With this patch, the port group state messag=
es are logged
> > > during boot
> > > =C2=A0=C2=A0=C2=A0=C2=A0 and access_state shows two active/optimized =
and two
> > > =C2=A0=C2=A0=C2=A0=C2=A0 active/non-optimized paths per LUN without a=
ny manual
> > > activate.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0 This fix is independent of the native multip=
ath series. It
> > > affects any
> > > =C2=A0=C2=A0=C2=A0=C2=A0 user of access_state/preferred_path, and ALU=
A prep_fn fast-
> > > fail, on
> > > =C2=A0=C2=A0=C2=A0=C2=A0 kernels with 50759b881e1d where nothing call=
s
> > > scsi_dh_activate()
> > > =C2=A0=C2=A0=C2=A0=C2=A0 after attach.
> > > =C2=A0=C2=A0=C2=A0=C2=A0=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0 v9 series:
> > > https://lore.kernel.org/linux-scsi/20261108204733.557995-1-
> > > =C2=A0=C2=A0=C2=A0=C2=A0 john.garry@linux.dev/
> > >=20
> > > =C2=A0 drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++++-
> > > =C2=A0 1 file changed, 8 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> > > b/drivers/scsi/device_handler/scsi_dh_alua.c
> > > index 87ac0a6d63e5..84ff3aed2c46 100644
> > > --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> > > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> > > @@ -1233,13 +1233,20 @@ static int alua_bus_attach(struct
> > > scsi_device *sdev)
> > > =C2=A0=C2=A0=09INIT_LIST_HEAD(&h->node);
> > > =C2=A0=20
> > > =C2=A0=C2=A0=09mutex_init(&h->init_mutex);
> > > +=09/*
> > > +=09 * alua_rtpg_queue() only queues an RTPG when sdev-
> > > > handler_data
> > > +=09 * points at this alua_dh_data, so set it before
> > > alua_initialize()
> > > +=09 * otherwise the initial RTPG issued from
> > > alua_check_vpd()
> > > is
> > > +=09 * silently dropped and sdev->access_state is never
> > > populated.
> > > +=09 */
> > > +=09sdev->handler_data =3D h;
> >=20
> > Note: I was checking which members of alua_dh_data are not
> > initialized=20
> > prior to publishing sdev->handler_data, and alua_dh_data.group_id
> > is=20
> > never accessed at all AFAICS.
> >=20
> > Thanks,
> > John
> On 11/15/26, John Garry wrote:
> > Do we still require this check (for h being non-NULL) after the
> change
> > in this patch? I assume that we flush any calls to this function
> prior
> > to unsetting sdev->handler_data.
>=20
> Hi John,
>=20
> Thanks for looking at this.
>=20
> You're right, with this patch the NULL check is redundant.

I vote for keeping the NULL check. It's cheap, makes it easier to
verify the code, and is a safeguard against future code changes
introducing breakage.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
