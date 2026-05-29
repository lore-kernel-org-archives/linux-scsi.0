Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BDE356748;
	Fri, 29 May 2026 01:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017615; cv=none; b=JHzTwgu7Wt75zWfThBN5fcCIHUPqFDLUxzpfnrqcR55r5boZQQ67oG5ckUiTuzifa+xBNsJx7rD65Sdblo2ubOAt8N2ZnhUIRpyDd87aO4SLRpBfynRVVsldCKrYGw/DXYezWbag90nSfquLBOG2zTl/1Ck/uILks6JMBeYFJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017615; c=relaxed/simple;
	bh=kc6nYMTZ15ADkL2c3/owXt8ybjc/HA+x3q8GPHZ/JeY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Mucuf1T2o9rilYt+0LtS6V6ute9g9KomgYHn9y+eKl1AZv3hICeLqetoqN+A/AgcusmNhH5DROAK0YINnpN2d6QoSIZvnQx4DtJwjMiaaxrL/2GCIVuWEks8rSHr1i42xpAthnpZsispuok87erNQ555BE9XCXhSBmRhPNsxIg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbd4O6b2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbd4O6b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48BB1F00A3A;
	Fri, 29 May 2026 01:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780017613;
	bh=daVD7h+JJCInltDYMlUpsr01UGPhOz1107R+/8g1GTw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=cbd4O6b25jNSiwHzC9tH6sPaVqcHXPLvjJ47C9KcyfA6pUwKpLaiRsnTbXEF0UZKr
	 NrkjKXHLp0yRDGS9Rc1RvUVmTSicK8iip/MbWWcx6I0cixnzJ1gCYmHHNKPKI27pME
	 O0BKTzvxvD+MnDvZteCkF9w2MHTxsW2nY7xuTrv0/KIjy+te1K+T4hf4Zf9H8fY8v6
	 FNBLyqcQmGOA1a1fls+y+g9MyxD80XFJKCok+8FtEF2/TwRLzQpDdujoVR6UycPPDL
	 LKYxReBnDyG81Fi54bLu+NuYxzFiyCrpY1Sj6s2rxY2Vky1JRbKF4eTOGouic2eG/+
	 7hd0dj5MCeAYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19BC1392FFFE;
	Fri, 29 May 2026 01:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 0/8] zorro: Improve handling of pointers in
 zorro_device_id::driver_data
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178001761763.1584301.12785828078106314359.git-patchwork-notify@kernel.org>
Date: Fri, 29 May 2026 01:20:17 +0000
References: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <cover.1779803053.git.u.kleine-koenig@baylibre.com>
To: =?utf-8?q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29_=3Cu=2Ekleine-koenig?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org,
	=?utf-8?q?=40baylibre=2Ecom=3E?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: geert@linux-m68k.org, dlemoal@kernel.org, cassel@kernel.org,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, tglx@kernel.org, mingo@kernel.org,
 max@enpas.org, andi.shyti@kernel.org, deller@gmx.de,
 linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 netdev@vger.kernel.org, linux-i2c@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 christian.ehrhardt@codasip.com, lk@c--e.de

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 May 2026 16:17:26 +0200 you wrote:
> Hello,
> 
> this series is about improving the handling of pointers in struct
> zorro_device_id's driver_data.
> 
> While it's ok on all current Linux platforms to store a pointer in an
> unsigned long variable, it involves casting that loses type information.
> This can be nicely seen in patch #7 where after profiting from patch #6
> the compiler notices a missing const.
> 
> [...]

Here is the summary with links:
  - [v1,net-next,3/8] net: Use named initializer for zorro_device_id arrays
    https://git.kernel.org/netdev/net-next/c/4933a658369a
  - [v1,6/8] zorro: Simplify storing pointers in device id struct
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


