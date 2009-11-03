From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] strstrip incorrectly marked __must_check
Date: Wed, 4 Nov 2009 04:06:49 +0900
Message-ID: <2f11576a0911031106r555f5515mc2bb2b1c0304cf87@mail.gmail.com>
References: <1257273488.9427.27.camel@mulgrave.site>
	 <20091103105921.160d5599.akpm@linux-foundation.org>
	 <20091103190420.GY10555@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:37161 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZKCTGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 14:06:44 -0500
In-Reply-To: <20091103190420.GY10555@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

2009/11/4 Matthew Wilcox <matthew@wil.cx>:
>
> =A0static inline void strsrip_tail(char *str)
> =A0{
> - =A0 =A0 =A0 char *x __used;
> - =A0 =A0 =A0 x =3D strstrip(str);
> + =A0 =A0 =A0 char *x =3D strstrip(str);
> + =A0 =A0 =A0 BUG_ON(x !=3D str);
> =A0}

Looks reasonable to me :)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
