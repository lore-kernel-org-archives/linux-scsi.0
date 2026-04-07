Received: from aib29agb123.bom1.oracleemaildelivery.com (aib29agb123.bom1.oracleemaildelivery.com [192.29.172.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ED22AD3D
	for <linux-scsi@vger.kernel.org>; Tue,  7 Apr 2026 04:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.29.172.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775537577; cv=none; b=XZ0isyepi5AcKJER2NnBjNNa8K+lpVbhCVaOLn9oxGfFgbnZlVw3W8dMuFTy/dTX3ipRlsmYyOY+NY4UcbfHrX/Jc12u2UuF+o6G5o8JHvI1CT0uhFryvJ49iMpZKrPfM4nBt9lOq8cV9Tou5shuS0tzaT/yM/vycWsm2qTot2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775537577; c=relaxed/simple;
	bh=DOGNxOuGnChhZQLwlrQLOpL2pK7O5LofYIVDLE+YYWc=;
	h=From:To:Subject:Date:Message-id:MIME-version:Content-type; b=GXSrNhVGCSqUjs/pHmJz6PP5YGfC7BhoTotj7yIlqR0c8blWTz9FYZLlm0VpPL0OidNMQCrvzrHlveIcIIjcR00O+asic0SgErraHyaVgdM5wDPge5SjjvVCkiGEtezTaaCy5m4pBPmAW0xVnZR815V0K1XjJ8ag2PFDM3SmbAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linknsell.com; spf=pass smtp.mailfrom=bom1.rp.oracleemaildelivery.com; dkim=pass (2048-bit key) header.d=linknsell.com header.i=@linknsell.com header.b=D6399Coj; dkim=pass (2048-bit key) header.d=bom1.rp.oracleemaildelivery.com header.i=@bom1.rp.oracleemaildelivery.com header.b=BjQ28lUa; arc=none smtp.client-ip=192.29.172.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linknsell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bom1.rp.oracleemaildelivery.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linknsell.com header.i=@linknsell.com header.b="D6399Coj";
	dkim=pass (2048-bit key) header.d=bom1.rp.oracleemaildelivery.com header.i=@bom1.rp.oracleemaildelivery.com header.b="BjQ28lUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=smtp.linknsell.com.20250508;
 d=linknsell.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender:List-Unsubscribe:List-Unsubscribe-Post;
 bh=DOGNxOuGnChhZQLwlrQLOpL2pK7O5LofYIVDLE+YYWc=;
 b=D6399Cojhch9tqD6JJ0CPlJsHqpEV5HUtPrflNiXmsrh8hloNdokEru0c+kc5ba9KqOC6YJcCn1A
   FaHklfzf4XSCWrlKvRPBZ65Rfsqqm28oKkvXNGeq3+mZg9aAbE922XWmQlyTeoPkb3ooRNOKpGYc
   up3/XvTYjwm6tVyTFVB9oktjg2ofHU5CLXVdIqu1Lfw4i2VifrhKA+OfYji+386w87bR438Zb0ry
   1TIDYaGa7Dx/9YuDckztSpK6VOUZELjgkBZSRu1jeRb317bX1GvjagZpsX930OIdYQJeJNOKnAiN
   GQALVkKsZe6X158yzN1PVfqGcmlgneVVzEp1wg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-bom-20200207;
 d=bom1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender:List-Unsubscribe:List-Unsubscribe-Post;
 bh=DOGNxOuGnChhZQLwlrQLOpL2pK7O5LofYIVDLE+YYWc=;
 b=BjQ28lUaaq4WH6atp/W8JH9GsxmKrESiA6jF3hHN8ciFtwDlOZ2MYNjYBnOLXie+0r6+zwGerHxV
   Nvkuhce5nimPfuWmFWSV9drDnZo/MNzA6UZjSwO0SBzpyWtUIRdFswaPL04ctjUCOsWn5d2DO3B/
   5j3CLPVTf8F6ZDyqN2fMuu4c4zNxxvCGo3nmDS88m2CbOZQVaPAhHgPSfWmuN/41sQ9tUUTtEOIx
   97pz1cOIAhp8eBjDICOrwBRxJa7nYtq5V8NGV6iyEpmw7Jk+gBpn9metz5i0j/FxgdGdSusk8iY7
   1fYGwLY00QCTGDuK6vcG+uHN1MMqWp379mSswA==
Received: by omta-ad1-fd1-402-ap-mumbai-1.omtaad1.vcndpbom.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20260212 64bit (built Feb 12
 2026))
 with ESMTPS id <0TD300EO7XK5VEA0@omta-ad1-fd1-402-ap-mumbai-1.omtaad1.vcndpbom.oraclevcn.com> for
 linux-scsi@vger.kernel.org; Tue, 07 Apr 2026 04:52:53 +0000 (GMT)
List-Unsubscribe-Post: List-Unsubscribe=One-Click
Reply-to: jisunlee@gmilweb.com
From: Jisun Lee <NoReply@linknsell.com>
To: linux-scsi@vger.kernel.org
Subject: I need your help
Date: 7 Apr 2026 05:52:50 +0100
Message-id: <20260407051725.6A9156BA15D86E46@linknsell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-version: 1.0
Content-type: text/plain;	charset="utf-8"
Content-transfer-encoding: quoted-printable
Reporting-Meta:
 AAGi5cWnrTT4y34B1qvDUxR1Rsnzi/bNdivngbcgnQHx1PzWyIJmi0ji+3UCCCnp
 D4cA0CnNMIO1lBduhQPAIOENYZguLw5sC/HWJmE1ap9+hdp0a8DnFEn0XFaIyrKL
 LVZi7XMQXOgSFHb3UKVhZbvwMG4/1AvY4lptiLS7HKUkb8I1An1owtMMm9wH0HfA
 7XUi9hz8vFQxxGWltH9v4w+xYZMIN0VUHz1K26HK1WvjdYVdRZP34RbAmQm/Uwc7
 X+kOYdLfcsm8ZcOsYWDKPDuP17YHCo3WwcJdiQ7ZwZHHD5JMX5dWIIZNVSWQwTd4
 lOlenWCHpPVg2bqL86RLYlF2MlGbjQpTh2DuGihly5iFmBKfvcG/Gg1JnXeSfZIY
 6Ai92K5VVwcXQSBMi+Ne/m+L3qepdPjA0qNlS0QejOwN9YkP5UXq6Xacdbqw3mkK
 3m+ipc5fWP9MT62fzoPKeQ2gUAuiHRqY9oyMqw1Lbq2mMFcphn+NSwTgNg==

Dear Beloved

My ex Husband Song Lee refuse to pay our divorce settlement
funds. =E2=80=8BI need your help to recover Assets from the bank for=20
healthcare and child support
=E2=80=8Bpurposes, diagnosed with (bladder cancer).

=E2=80=8BI need your advise and support

=E2=80=8BThank You
Jisun Lee
