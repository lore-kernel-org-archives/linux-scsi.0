Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=128.116.240.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794135010;
	b=DnHOCjSpZ0huoJ+86/Vcpz0L330rtf7gijfocRmYUEpvckp4cvGtAOSrJZJ5m1FXrSUt
	 KAwxDrv2m++g0tNRagmSmTgBG1TOAGcgHYrOPNE3QBZoDUkcE+Z8sIlrTX/Npby+1IZCy
	 49n0GRff6npvVEh+HB3ptwirapKEpMGASmNdoDYlKBkwAwNtZOIRFN8tjODMDt882IPEN
	 e81yRVDbM046DIoev57ZnTl6XPyKFQqXe3g3dpbh6DdPfDF7ahSCrHxKwP4cVMS5NL10i
	 lH9F/OazT98sqdzYFbMTihrZvwGn/zGaW5+R+spIymLk9PxPcDT5WIfDtmWFDP4HVkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794135010;
	h=DMARC-Filter:DKIM-Signature:Received:Mime-Version:
	 Content-Transfer-Encoding:Content-Type:Date:Message-Id:Cc:Subject:
	 From:To:X-Mailer:References:In-Reply-To;
	bh=8pq/IDSCY4LBixR6A7q8Ut/Zwku91AwAfepkFX7dr7A=;
	b=RwB0fByIODtbA0RBkWancp8G1ak6Rqki3iP2No6U7Dqsf1J88t1mWyfa6HhnX9Ngj25V
	 dQJx7tjH1zH+SRqXF7yN/cWaTB+W2fAYP0pXtkV1YN9HcT1EH15NW+oCP2h2GD4MlBgre
	 ehk0SheZqiZUmqy+x8tcsVtlPniaNUVlodtPXcXEfvCpu8lvlBXFEuku//awOvOoUOyRn
	 xcfWhCnmLLAUqezFHt54aTfjWEEpNgUJlPmMWBwJxkryNFxSfMGwHwbBqjNtukETwYB5G
	 PdEaQZhBMXMfhgPw8WVmn3pgrs/THMlXBsJP1ZkPhabnMYExNM4mAuoenhht8/xBaUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arkamax.eu;
	spf=pass smtp.mailfrom=arkamax.eu;
	dkim=pass header.d=arkamax.eu header.i=@arkamax.eu header.a=rsa-sha256 header.s=mail1 header.b=l6JqTey+;
	arc=none smtp.remote-ip=128.116.240.228
Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BC606A31C;
	Sun,  8 Nov 2026 10:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C93BC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arkamax.eu header.i=@arkamax.eu header.a=rsa-sha256 header.s=mail1 header.b=l6JqTey+
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=0acOCyvV6JrPcx
	ohfcRhMPkj9sEYJAZOtcKos1dv26U=; h=in-reply-to:references:to:from:
	subject:cc:date; d=arkamax.eu; b=l6JqTey+gSc2m70BjbSxBgD7zMF0t0DV4LBvM
	o1pqJIOCm3IMx47zpfjkDJrA4vBVWdOx3MCk9an8r3TtOHPXndgiMJbwA5WpCwTDE/T8k2
	STjen5tnqUfRj/yTPK/P+cQME4JUZBw6hLv6gcz+OcCItbsHU43DR6G8uD2KddBjx0O4I7
	Mv0++t2IPByKWaxU9NTz/oSd9yUpdxEOTS237OOO7HwurXZ31IvHARGyfl+6bi7GcQXgx/
	3DOOOkRpZ/rYX2GEvBaKcT/FHSTjH8AFD4QSUr8FQ7Mw4OqKCXYslV/p2PvLg030AS7bHC
	yFu+hOZop+mH7jB9XF3tewung==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 8c21eb9d (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 8 Nov 2026 11:50:00 +0100 (CET)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 08 Nov 2026 11:50:00 +0100
Message-Id: <DMPRS0MF3KC3.1H1C97P5ES18@arkamax.eu>
Cc: <michael.christie@oracle.com>, <linux-scsi@vger.kernel.org>,
 <linux@yadro.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Dmitry Bogdanov" <d.bogdanov@yadro.com>, "Martin Petersen"
 <martin.petersen@oracle.com>, "Maurizio Lombardi" <mlombard@redhat.com>,
 "Laurence Oberman" <loberman@redhat.com>, <target-devel@vger.kernel.org>
X-Mailer: aerc 0.20.0
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
In-Reply-To: <20261027180123.13163-1-d.bogdanov@yadro.com>

On Tue Oct 27, 2026 at 7:01 PM CET, Dmitry Bogdanov wrote:
> ISCSI has some old leftovers in the code that prevents passing the aborte=
d
> command to the target core to make the actual abort. Such commands hang
> until connection is closed.
> So remove those leftovers.
>
> Dmitry Bogdanov (2):
>   Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
>     commands"
>   scsi: target: iscsi: fix hanging WRITE_PENDING commands
>
>  drivers/target/iscsi/iscsi_target.c      | 19 -------------------
>  drivers/target/iscsi/iscsi_target_erl1.c |  8 --------
>  2 files changed, 27 deletions(-)

Sorry for the late reply, I was on vacation.

I like this solution and since Laurence tested it and confirmed that it wor=
ks
then I am completely ok with reverting my patch.

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
