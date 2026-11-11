Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395699;
	b=RNQZB3Q0cE/u1YXsXyotOyQ6oW+2HFrRb0qRazatyeqC2ElgAr41kprhM9DnKytRSxyS
	 dQXVdCcqJe82hTmHTMapFij0+R+YhZp8CuvH4HXK1O17oZINSY9L7sexPRL1coA0SpM4C
	 BJLeCznkpqlEnXWMMKASGtDJ40xoARdkd3NXmBUWftmWiu/0yG2QJf7PtjG49UGJnxOYS
	 XNqDefTPXu4RutMs2IfbJyol8AuHgWfdd1kIeqxHeni6lqyRPBWrsoUi4odBozJcuvA1x
	 0lWKU044A4PWHhDXkdf59Mn3ip2gQAVuMy0vyueBTlZHpPAfnFBz168XVwLy1JbOXPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395699;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=6dWidwcEKUfUEi7w888BD8eID4nuX6dXjB3OdH+5k40=;
	b=JbBjTuk/JDkY+GstptmNmRYw2qXhsTu3BuuyqyNEDlWtiMYOV52wOVIsCq1easVo/zvm
	 wk1GI35qjmQdyTF2726XYBSWc1aBVN1DSjZ1EKozWZDHxXoRkfy1UekM0gbgfUnj85hcN
	 UYXVcavDEqMjlhKV5oo08R6SgPOzWvtPcxlW3JEKG1ckZj3FM6rHPAyc/MRz3T61efI89
	 /a6uxtAgogck2DXYDtagA0rVr5hBvrFEwK0FmR1hGuafrWcXbHLJ/5ranLQkZ03hXt+5i
	 2x+woDL7iqoTxcN5BqDiKN1dGfqkAcZfJvAx5UkEcaX+Y+1azplOQk3gnkMuLISmlcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gXL7ldem;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gXL7ldem;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795EE606A31C;
	Wed, 11 Nov 2026 11:14:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 795EE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gXL7ldem;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gXL7ldem
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7768E1F7C3;
	Wed, 11 Nov 2026 11:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794395696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dWidwcEKUfUEi7w888BD8eID4nuX6dXjB3OdH+5k40=;
	b=gXL7ldemcetBD0kQa+Jdld3Q27jHfk8SC8ooYRvSUDN54ouOBSiI03ZVjxZUona0GQ4xFN
	XAV0bPJUOXF/vOCDjlanhP2+cHMGJVStpngASDjEMGZrBZEWEb6CbxFBp+2m5OIvIE1UQF
	PVy4CA8A5vnmCinLSsgd4ZDVTGNeIHQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gXL7ldem
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794395696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dWidwcEKUfUEi7w888BD8eID4nuX6dXjB3OdH+5k40=;
	b=gXL7ldemcetBD0kQa+Jdld3Q27jHfk8SC8ooYRvSUDN54ouOBSiI03ZVjxZUona0GQ4xFN
	XAV0bPJUOXF/vOCDjlanhP2+cHMGJVStpngASDjEMGZrBZEWEb6CbxFBp+2m5OIvIE1UQF
	PVy4CA8A5vnmCinLSsgd4ZDVTGNeIHQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 266601339F;
	Wed, 11 Nov 2026 11:14:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f//oATBO9GrHRAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Nov 2026 11:14:56 +0000
Message-ID: <b2801471f9083e96a309491ca68b7c917f0f7cee.camel@suse.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: set handler_data before
 alua_initialize()
From: Martin Wilck <mwilck@suse.com>
To: Laurence Oberman <loberman@redhat.com>, "Martin K . Petersen"
	 <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,  Bart
 Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@kernel.org>, John
 Garry <john.g.garry@oracle.com>, 	linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Date: Wed, 11 Nov 2026 12:14:55 +0100
In-Reply-To: <20261109201120.1067815-1-loberman@redhat.com>
References: <20261109201120.1067815-1-loberman@redhat.com>
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 7768E1F7C3

On Mon, 2026-11-09 at 15:11 -0500, Laurence Oberman wrote:
> Since commit 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context"), alua_rtpg_queue() only
> queues an RTPG when sdev->handler_data points at an alua_dh_data
> whose
> port group matches:
>=20
> =09struct alua_dh_data *h =3D sdev->handler_data;
> =09...
> =09if (h && rcu_dereference(h->pg) =3D=3D pg) {
>=20
> However alua_bus_attach() only assigns sdev->handler_data after
> alua_initialize() returns, and alua_initialize() -> alua_check_vpd()
> is where the initial RTPG is queued. At that point handler_data is
> still NULL, so the initial RTPG is silently dropped: no RTPG is sent,
> nothing is logged, and sdev->access_state keeps its zeroed default of
> active/optimized for every path.
>=20
> With dm-multipath this goes unnoticed, as pg_init calls
> scsi_dh_activate() once the map is loaded, which queues an RTPG after
> handler_data is set, and multipathd's alua prioritizer issues its own
> RTPG from userspace. Anything relying on sdev->access_state without a
> subsequent activate (sysfs access_state/preferred_path, native SCSI
> multipath path selection) sees every path as active/optimized until a
> Unit Attention or rescan triggers an RTPG.
>=20
> Seen on an HP P2000 G3 FC array (implicit ALUA, two port groups, four
> paths per LUN) with dm-multipath not in use: sg_rtpg reports port
> group
> 0 active/non-optimized and port group 1 active/optimized, but
> /sys/class/scsi_device/H:C:T:L/device/access_state reads
> active/optimized on all four paths after boot, and no
> "alua: port group XX state ..." message is logged. Writing "activate"
> to dh_state sends the RTPG and corrects access_state.
>=20
> Kernels without commit 50759b881e1d queue the attach-time RTPG
> unconditionally and are not affected.
>=20
> Fix by assigning sdev->handler_data before calling alua_initialize(),
> and clearing it again on failure. sdev->handler is only set once
> scsi_dh_handler_attach() sees ->attach() succeed, so no handler
> callback can observe the partially initialised alua_dh_data. On the
> failure paths of alua_initialize(), h has not been added to a port
> group and no RTPG has been queued, so freeing it is unchanged.
>=20
> Fixes: 50759b881e1d ("scsi: device_handler: alua: Call
> scsi_device_put() from non-atomic context")
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurence Oberman <loberman@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
