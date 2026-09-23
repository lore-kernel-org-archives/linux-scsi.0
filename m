Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1B64963C8;
	Wed, 23 Sep 2026 15:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790176304; cv=none; b=QnzehvpY7VDYONuC1ZElnR5J+ZN0o84mSDC+R5UybRvEwaCXsVA9hCCjMvMdVAFyU/t3711XuXVdJg24srhlpa1cPOPcJOMFEZjBmU4zNn2oHcvfeqD6GjS8OsWOuj+ilSZe2ZuENyYKECpz5L8+7F0n6MUEkM2QqxCzT35ukhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790176304; c=relaxed/simple;
	bh=aBa1zViSf6k5lnn2CjYpnYIfK45SjV7yAKpjdT8bzPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z3aM/F8f/iJjqz4nWbMD4BRdaUGRA3lhcI5SsW9MRpip3UYZVqaiCsMk4+QuXJWqJKQy3NCMBl0g6WTurru/QcLfuyxN7qwftwGmJLRRfUU42pBIFfhAFt1E0oWD2u8Bitl+1/AVdTb3+aL54qTsXv+gokb5ax9K03AkqleiDX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=HO7hLa+k; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="HO7hLa+k"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 9B5ED8103C;
	Wed, 23 Sep 2026 17:11:38 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id WYmLkaiFmclZ; Wed, 23 Sep 2026 17:11:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1790176298; bh=aBa1zViSf6k5lnn2CjYpnYIfK45SjV7yAKpjdT8bzPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HO7hLa+k9q5VNF3swfPpi2OLVT0BVUOnm6uo1y++POUfGlMTJBjjw2+h2DG/aWfXb
	 Gu+AlMdCmmOB63bJMseFRa7CElaDkUW8kk1L8xQKni8JAAHSmwgtjyvbuhC8PvP8KM
	 TPR8B8axaVteKcfjXk97M8BzL0RyyhBlL/udsBvhYoyLhCh1twP7SDRhXUuyO1EM5m
	 q0HHR+GXJVyTmpO941yD3FAdthSb+fzLjUuDUMWvSkxF7xjrWo0zhZvUoPn/bf8ttd
	 dNfYtvPjQS8/rHZmSizyuerHQAuGbpGvYbxLrkgADw7aVLQoKJ6BYU+wqEUTYXLAlB
	 vcGgj1n+Jr1Aw==
From: Marco Scardovi <scardracs@disroot.org>
To: Denis Benato <denis.benato@linux.dev>,
 Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
 Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, "Martin K.  Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 "Derek J.  Clark" <derekjohn.clark@gmail.com>,
 Ahmed Yaseen <yaseen@ghoul.dev>
Subject:
 Re: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG
 NVMe enclosures
Date: Wed, 23 Sep 2026 17:11:24 +0200
Message-ID: <UuqOxFagT_OBL0l5ZYtfKg@disroot.org>
In-Reply-To: <202609240122.ReplyDenis.lhw@gmail.com>
References:
 <52904b48-a5fa-4872-b9bf-a05b1b7bdea2@linux.dev>
 <202609240122.ReplyDenis.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

In data mercoled=C3=AC 23 settembre 2026 14:59:36 Ora legale dell=E2=80=99E=
uropa centrale,=20
Liang Haowen ha scritto:
> Hi Denis,
>=20
> Thanks for the context.
>=20
> I have read Marco's Dynamic Lighting class series (PR #17). The
> direct frame and palette interfaces map cleanly onto what the Arion
> needs: its colour tables are just small RGB frames, and the
> enclosure firmware effects map onto the class effect controls. I
> will coordinate with him on using it for the LED side, on top of
> the verified SCSI handling this series carries.
>=20
> On the open review items: the next revision will isolate the DMA
> buffer into its own cacheline (a real issue on non-coherent
> architectures, as the bot notes), and I will take the time to get
> the full pass right instead of rushing again.

Hi everyone,

as for now please consider the new interface as a far from done one: it has
basic functions and works good on my laptop but, that means it is tested
only on my device using kernel 7.2.y. If you have time and want to test it
out/give feedbacks they are more than welcomed (tbh I've yet to address
these given by @Dereck due to personal reasons but I promise I'll work
on them too asap).

@Liang if you look into it there is a basic version of SCSI for your device
using the new interface: if you want to look at it feel free to do so/sugge=
st
changes: I'll probably drop it in a future rebase to make the patchset
smaller (then again I'll have to do countless threads here in lore for leds=
,=20
hid, wmi, etc etc etc so it will take months).

Best regards,
Marco



