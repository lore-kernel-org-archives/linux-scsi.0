Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795108335;
	b=TNhtEUqDGI+4QDh8TKuVxarU4cVBr9K9CsckISKW2Qs8JEG3wYZy/jfkVqA4K23xxNZD
	 8a+PjZTCrzJZcnAuBVC/20r3IyacuIrs2WbXnLmvKMubAwMv2PoSnK5rPb7aMfaU5/URQ
	 kneyN443EAZAzKCl3ILxz7HsqTmyve0tjv6RLtdD5aviUVZT2v1gc2RxUNqydrUDh/13R
	 4HJtvwFsAl7lWZQeaiUuufuq5E5kG89nPU+ds7eJi0mGYOR3HRntMH28mTBA2k0aqci5s
	 oXt/hXtxrdmF59F0wJOFVpDqHEXUrvAptmHhCslKEF2nBDhv3bbZG91V0aJoqqhNb7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795108335;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E3wYUAG6DfKshzxzCtpl2+Up/xVj/FKCUpfb+8HOCx0=;
	b=qC2FRdxxlLP0PGZ1tExi6Pcklry9ELplyFPLu/zjCgAQlLJ8eQmFTJEGNmfySsHZvWAM
	 WY0BPCDQL1a5fJl9NbDk3OTEo1N1MoIJbftktLirz+7lyl9Se44axWdNatVscYmK9JDbq
	 OpASZS06svoRjVJICUR5agiNb9BUMt4R2UcJDYQ+78mi27BwBb3QQeANy6zDMgX70bFlZ
	 lKCIu3XqfoSolFZx/pb8HY1YGhLYU4Hdgw5uK+JCDzT4vUrqTXSVaysvsFUb6EQ3D/FUK
	 T+xykbCDjlHw7YtHyTv/ph8eDJQIx4ABjMNAJVbBITMG6M8GVhCTlRp0vQi2ml5+BTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q7tRqYS8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1785E606A32F
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q7tRqYS8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B5F1F000C4;
	Thu, 19 Nov 2026 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795108334;
	bh=E3wYUAG6DfKshzxzCtpl2+Up/xVj/FKCUpfb+8HOCx0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q7tRqYS8tS3yuGag6WiFA7nQwcBPmqBdFzB2vxrAEKRcyBvajGK2rskVUmHGvPn5O
	 Skcn8gPmADWoAriI0XMFvZ5z0FiOjaoSiZtL+e7ZBCfwS+qJHTNwLcyRe/dHH6wjMf
	 4g5SUVOSRg5hCFq3oGkWZ7udEoTq45EBio5AeMh/UdaW3EhjUVMcDX6PAOoALSpZ/W
	 eIELdClc5YKFf06lRKMe3jGtTMQRxj9qRVdVy6A3SILcqkfYB+GtF+JAPjncGcWoar
	 dGDlprNiqqVB4lqAWGdnPwrDaulh//Z9sJ6NIFnb807WS7K39I9rc5bL5kIKCBhgF+
	 KZ/9zVKr9JaoQ==
Message-ID: <sashiko-outbox-223648@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Format SFP EEPROM vendor strings with
 %.*s
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261119170511.1515433-1-irogers@google.com>
References: <20261119170511.1515433-1-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 17:12:14 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] scsi: qla2xxx: stack buffer overflow in
  qla2xxx_print_sfp_info() [1]
--

commit fc46a24e989dac1a4fa69f172af87de567da0070
Author: Ian Rogers <irogers@google.com>

scsi: qla2xxx: Format SFP EEPROM vendor strings with %.*s

This commit replaces snprintf() calls that passed SFP EEPROM vendor name and
part number fields directly as format strings in qla2xxx_print_sfp_info()
with "%.*s" formatting in ql_dbg().

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ccb039d97353b..77504cfc07411 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4126,15 +4126,13 @@ static void qla2xxx_print_sfp_info(struct scsi_ql=
a_host *vha)
>  	if (!(ql2xextended_error_logging & ql_dbg_verbose))
>  		return;
> =20
> -	memset(str, 0, STR_LEN);
> -	snprintf(str, SFF_VEN_NAME_LEN+1, a0->vendor_name);
>  	ql_dbg(ql_dbg_init, vha, 0x015a,
> -	    "SFP MFG Name: %s\n", str);
> +	    "SFP MFG Name: %.*s\n",
> +	    (int)sizeof(a0->vendor_name), a0->vendor_name);
> =20
> -	memset(str, 0, STR_LEN);
> -	snprintf(str, SFF_PART_NAME_LEN+1, a0->vendor_pn);
>  	ql_dbg(ql_dbg_init, vha, 0x015c,
> -	    "SFP Part Name: %s\n", str);
> +	    "SFP Part Name: %.*s\n",
> +	    (int)sizeof(a0->vendor_pn), a0->vendor_pn);
> =20
>  	/* media */
>  	memset(str, 0, STR_LEN);

[Severity: Critical]
This problem wasn't introduced by this patch, but can the media block
immediately below overflow str[] [1]?

drivers/scsi/qla2xxx/qla_init.c:
#define PRINT_FIELD(_field, _flag, _str) {		\
	if (a0->_field & _flag) {\
		if (p) {\
			strcat(ptr, "|");\
			ptr++;\
			leftover--;\
		} \
		len =3D snprintf(ptr, leftover, "%s", _str);	\
		p =3D 1;\
		leftover -=3D len;\
		ptr +=3D len; \
	} \
}

drivers/scsi/qla2xxx/qla_init.c:qla2xxx_print_sfp_info() {
    ...
	/* media */
	memset(str, 0, STR_LEN);
	ptr =3D str;
	leftover =3D STR_LEN;
	p =3D len =3D 0;
	PRINT_FIELD(fc_med_cc9, FC_MED_TW, "Twin AX");
	PRINT_FIELD(fc_med_cc9, FC_MED_TP, "Twisted Pair");
	PRINT_FIELD(fc_med_cc9, FC_MED_MI, "Min Coax");
	PRINT_FIELD(fc_med_cc9, FC_MED_TV, "Video Coax");
	PRINT_FIELD(fc_med_cc9, FC_MED_M6, "MultiMode 62.5um");
	PRINT_FIELD(fc_med_cc9, FC_MED_M5, "MultiMode 50um");
	PRINT_FIELD(fc_med_cc9, FC_MED_SM, "SingleMode");
    ...
}

str[] is 64 bytes (STR_LEN), while the seven media strings and their "|"
separators total 83 characters plus the NUL terminator.  Because snprintf()
returns the length that would have been written rather than the truncated
length, when all seven FC_MED_* bits are set in a0->fc_med_cc9, the sixth
PRINT_FIELD() drives leftover negative and advances ptr past the end of
str[], and the seventh writes out-of-bounds on the stack via strcat() and
triggers WARN_ON_ONCE() in vsnprintf().

[1] https://sashiko.dev/#/bug/linux-684c2982-ba32-44da-bc9c-910dc2c357ef

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119170511.1515=
433-1-irogers@google.com?part=3D1
