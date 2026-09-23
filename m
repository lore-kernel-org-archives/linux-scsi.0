Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0FF49482D;
	Wed, 23 Sep 2026 10:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160113; cv=none; b=kfa9clEK0xruXYs5ZzWjrwy5dH2LfayQGUXqbI3lViuR2kbGNn46yA9u0UZ52uNQtFcRS425tJ3yyOAf98DGy7RrSoimNTGZV7Kjl0cMpE5XMrInxMwvLG3kZebvh2EWTKSLCiUiXUOxcxpRbqJ9Lz8Z6u3oF5crWe0I9snbbvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160113; c=relaxed/simple;
	bh=ct2Yxd6Pwb6wJQGDaDkNSWm2xACRUao6jBghy3Rxpo8=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pnGPE/gdwUl3D7TGtds8rpRUrDrEmc/f5y7oNxZpW45EwlK7ITS8thBrgWwqnPHGLMrMJgaclBJ4gJuR3Enj9R1hOHsa8h9/spQy8ve+a8pFGzQmWJ++Fooic1EeB1fqgs5FoRTo3qBqQRIj7mTwWpHL3PKaz2x/trJvuQ8I5co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHxBj2eN; arc=none smtp.client-ip=192.198.163.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHxBj2eN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790160101; x=1821696101;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=ct2Yxd6Pwb6wJQGDaDkNSWm2xACRUao6jBghy3Rxpo8=;
  b=nHxBj2eNmyds7NR8GKecNHB5jRPCXjJ/6TEVIPM7kajalQczq+Wu85p8
   P60JGCnis8TPg1xtM7CyeRx/2KC820mYHUFwQy25FCuxWt0h/OBXNR5g3
   cI+lYp5zyP5Bt2tiGu2BswCLrkQ97vrehi1p9SF0alAtSLwUqbLiESd/R
   InqoHzD+2/d+UxaEOSSYQxh2lwJzbLeDdrUqgPp3+dSgsI5lSf8zN6hIR
   pReBgL4Z2UEl8bxoQ0tn+Id+Ev50wcQ1jvG14TqeUDHE89ru+a6iYO3kF
   W7ph4kqVkLCAZMbuJgWCfIuyGAf8U4zuSD0+ZmgfKvlxySOYoRVSNEvhF
   Q==;
X-CSE-ConnectionGUID: efyTlCreRluAcZ5Vk4nfIg==
X-CSE-MsgGUID: YTT5STjvQCimnRFRzOwW8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="1356685"
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="1356685"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa114.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 03:41:36 -0700
X-CSE-ConnectionGUID: Ju1AiwyyS0Ko+5L/1UwU9w==
X-CSE-MsgGUID: p+Gh/wKeSbKl6XnkHPzDxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,118,1787036400"; 
   d="scan'208";a="4644288"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.244.13])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 03:41:31 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 23 Sep 2026 13:41:27 +0300 (EEST)
To: Liang Haowen <nbg2974@gmail.com>
cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>, 
    Pavel Machek <pavel@kernel.org>, "Martin K . Petersen" <mkp@kernel.org>, 
    linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org, 
    LKML <linux-kernel@vger.kernel.org>, Denis Benato <denis.benato@linux.dev>, 
    Armin Wolf <W_Armin@gmx.de>, Hans de Goede <hansg@kernel.org>
Subject: Re: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
In-Reply-To: <20260923103015.2365773-1-nbg2974@gmail.com>
Message-ID: <d6cd20f2-dbad-58c5-d356-b9d1fa97ea44@linux.intel.com>
References: <20260923103015.2365773-1-nbg2974@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 23 Sep 2026, Liang Haowen wrote:

> Hello,
> 
> v7, as its own thread, addressing Lee's review of v6.

No, you didn't address Lee's comments but only a small part of them. :-(

Please slow down so you've time to address all feedback properly and 
double check before the next submission you've addressed all feedback 
you've received, not just part of it.

In case you think there's a comment where the reviewer is wrong, do not 
just silently ignore reviewer comments but engage by explaining why you 
think the patch is fine as is.

-- 
 i.

> Changes since v6:
> 
> - The driver moved to drivers/leds/rgb/, where the other multicolor
>   LED drivers live.
> 
> - The series is submitted with git send-email this time, so the
>   patch format is the standard one.
> 
> The SCSI device handler attachment is unchanged; why it is a device
> handler at all, and what the in-tree split should look like, is the
> open discussion in the v6 thread.
> 
> Everything else is unchanged from v6: the hardware description, the
> scsi_device_handler that does not claim the sdev, the multicolor LED
> interface, the protocol handling and the known caveats (manual
> attach until the split lands; SAVE on every update writes the
> enclosure flash, wear uncharacterized; NULL-parent LED registration
> to avoid the sdev reference cycle).
> 
> Liang Haowen (1):
>   leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe
>     enclosures
> 
> 

