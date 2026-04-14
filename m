Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B75275AE4
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 03:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776137551; cv=none; b=h+7oS8ZKsYTQHFJHqJCnKY6zl4X4E8g/YVO5xmsWG6J16eFEpAXwXZKBpGVEgD7L7BdGX/wEoJG8QAOzFGZ+/lay5nmT/xkMI4+0p7db06OnVnrzJ6B+FfVBl5LlEmt5sCHpNo07r6gBkjW4wR+XBf4Gsb00QvFx6yZs9AU93xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776137551; c=relaxed/simple;
	bh=bwgMACwiXb9QBX/GUscwZSjtI4EHWUgYIvGymEG61YA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TOHQN3B95iYASfrUkHw7chLB9mU0IR53c3ab8dsuxCmhzql6X2KeyojGPLpIyVE/4iC3cOpUtmta6UH+JhDie1aXLEEw6RqGOdTLXe1yOXCHvSDufuiKw+QqajXAVrFmVSGFjsLMk8cl/e+ta3xxw2h13PKkLyWZOx0zZsxZSSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: O/L4Ksf5SxmEL2P3HmsyUQ==
X-CSE-MsgGUID: +HHw3vkLS8GXHy6fc9EEMQ==
X-IronPort-AV: E=Sophos;i="6.23,178,1770566400"; 
   d="scan'208";a="172727058"
From: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>
To: <bvanassche@acm.org>
CC: <James.Bottomley@HansenPartnership.com>, <adrian.hunter@intel.com>,
	<alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <beanhuo@micron.com>,
	<linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <wanghui33@xiaomi.com>, <wangshuaiwei1@xiaomi.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS mode
Date: Tue, 14 Apr 2026 11:32:25 +0800
Message-ID: <20260414033225.1454960-1-wangshuaiwei1@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b8f882ae-ddce-4ab5-8c8a-28efdc31bee5@acm.org>
References: <b8f882ae-ddce-4ab5-8c8a-28efdc31bee5@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJ-MBX03.mioffice.cn (10.237.8.123) To bj-mbx11.mioffice.cn
 (10.237.8.131)

On Mon, 13 Apr 2026 08:46:48 -0700, Bart Van Assche wrote:
> On 4/13/26 2:11 AM, Wang Shuaiwei wrote:
> > +	if ((SLOW_MODE == rx_mode || SLOWAUTO_MODE == rx_mode) &&
> > +	    (SLOW_MODE == tx_mode || SLOWAUTO_MODE == tx_mode))
> > +		return LS_MODE;
> 
> A stylistic comment: please follow the coding style that is used
> elsewhere in the Linux kernel. In this case, that means no Yoda
> conditions. As an example, "SLOW_MODE == rx_mode" should be changed into
> "rx_mode == SLOW_MODE".

Hi Bart,

I will modify the coding style in the next version.

Thanks,
Wang Shuaiwei.
